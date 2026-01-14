#!/bin/bash

# Çekirdek fonksiyonları dahil et
. ./core.sh

# --- TEMA AYARI ---
export GTK_THEME=Adwaita:dark

# --- 1. GİRİŞ FORMU ---
# --image: Sol tarafa ikon ekler (sistemdeki ikon adlarını kullanır)
# --file-selection --file-filter: Sadece PDF seçtirir
FORM=$(yad --form --center \
  --title="PDF Sıkıştırma Stüdyosu" \
  --window-icon="application-pdf" \
  --image="drive-harddisk" \
  --text="<big><b>PDF Optimizasyon Aracı</b></big>\nLütfen ayarlarınızı yapın:" \
  --width=500 \
  --field="PDF Dosyası:FL" \
  --field="Sıkıştırma Seviyesi:CB" \
  --file-filter="PDF Dosyaları | *.pdf" \
  "" "dusuk!orta!yuksek")

# İptal edilirse çık
if [ $? -ne 0 ]; then
    exit 0
fi

GIRIS_PDF=$(echo "$FORM" | cut -d'|' -f1)
KALITE=$(echo "$FORM" | cut -d'|' -f2)

# Girdi kontrolü
if [ -z "$GIRIS_PDF" ]; then
    yad --error --title="Hata" --text="Dosya seçilmedi!" --center
    exit 1
fi

# Çıktı yolu
DIZIN=$(dirname "$GIRIS_PDF")
DOSYA=$(basename "$GIRIS_PDF" .pdf)
CIKIS_PDF="$DIZIN/${DOSYA}_kucuk.pdf"

# --- 2. İŞLEM VE İLERLEME ÇUBUĞU ---
# İşlem boyutuna göre süre değişeceği için "pulsate" (gidip gelen çubuk) kullanıyoruz.
# İşlemi arka planda yaparken kullanıcıya bilgi veriyoruz.

(
    echo "10" ; sleep 0.5
    echo "# PDF analiz ediliyor..." ; sleep 0.5
    echo "30" 
    echo "# Ghostscript motoru başlatılıyor ($KALITE)..."
    
    # Asıl işlemi burada çağırıyoruz
    pdf_islemi_calistir "$GIRIS_PDF" "$CIKIS_PDF" "$KALITE"
    
    echo "90"
    echo "# Tamamlanıyor..." ; sleep 0.5
    echo "100"
) | yad --progress \
  --title="İşleniyor" \
  --text="PDF sıkıştırılıyor, lütfen bekleyin..." \
  --pulsate \
  --auto-close \
  --auto-kill \
  --center \
  --width=400

# --- 3. SONUÇ HESAPLAMA VE RAPOR ---

if [ -f "$CIKIS_PDF" ]; then
    ESKI_BYTE=$(stat -c%s "$GIRIS_PDF")
    YENI_BYTE=$(stat -c%s "$CIKIS_PDF")
    
    # Okunabilir boyuta çevirme fonksiyonu
    human_size() {
        numfmt --to=iec-i --suffix=B $1
    }

    ESKI_FMT=$(human_size $ESKI_BYTE)
    YENI_FMT=$(human_size $YENI_BYTE)

    # Kazanç hesaplama
    if [ $ESKI_BYTE -gt 0 ]; then
        ORAN=$(( 100 - (YENI_BYTE * 100 / ESKI_BYTE) ))
    else
        ORAN=0
    fi

    # Sonuca göre mesaj rengi ve ikon belirleme
    if [ "$YENI_BYTE" -gt "$ESKI_BYTE" ]; then
        ICON="dialog-warning"
        MSG="<span color='orange'><b>Dikkat:</b> Dosya boyutu büyüdü.</span>\nBu dosya zaten sıkıştırılmış olabilir."
    else
        ICON="emblem-default"
        MSG="<span color='#2ecc71'><b>Başarılı!</b> Dosya boyutu küçültüldü.</span>"
    fi

    # Detaylı Rapor Penceresi
    yad --title="İşlem Özeti" \
        --window-icon="application-pdf" \
        --image="$ICON" \
        --center \
        --width=400 \
        --button="Kapat:0" \
        --button="Dosyayı Aç:1" \
        --text="
<big><b>Sonuç Raporu</b></big>

$MSG

<b>Orijinal:</b>\t$ESKI_FMT
<b>Yeni Hali:</b>\t$YENI_FMT
<b>Kazanç:</b>\t%$ORAN

<i>Dosya konumu:</i>
<small>$CIKIS_PDF</small>"

    # Kullanıcı "Dosyayı Aç" derse (Exit code 1 dönerse)
    if [ $? -eq 1 ]; then
        xdg-open "$CIKIS_PDF" 2>/dev/null &
    fi

else
    yad --error --title="Başarısız" --text="PDF oluşturulamadı. Bir hata oluştu."
fi
