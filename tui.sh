#!/bin/bash

# Çekirdek fonksiyonları dahil et
. ./core.sh

# --- 1. PDF DOSYA SEÇİMİ ---
GIRIS_PDF=$(whiptail --title "PDF Boyut Küçültme (TUI)" \
--inputbox "İşlem yapılacak PDF dosyasının tam yolunu giriniz:" 10 70 \
3>&1 1>&2 2>&3)

# İptal veya boş giriş
if [ $? -ne 0 ] || [ -z "$GIRIS_PDF" ]; then
    exit 1
fi

# Dosya var mı kontrolü
if [ ! -f "$GIRIS_PDF" ]; then
    whiptail --title "Hata" \
    --msgbox "Girilen yolda PDF dosyası bulunamadı." 8 50
    exit 1
fi

# --- 2. KALİTE SEÇİMİ ---
KALITE=$(whiptail --title "Kalite Seçimi" \
--menu "PDF sıkıştırma seviyesini seçiniz:" 15 70 3 \
"dusuk"   "En düşük boyut" \
"orta"    "Dengeli (Önerilen)" \
"yuksek"  "En iyi kalite" \
3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then
    exit 1
fi

# --- 3. ÇIKTI YOLU ---
DIZIN=$(dirname "$GIRIS_PDF")
DOSYA=$(basename "$GIRIS_PDF" .pdf)
CIKIS_PDF="$DIZIN/${DOSYA}_kucuk_tui.pdf"

# --- 4. İŞLEM (GAUGE) ---
{
    echo 20
    sleep 0.5
    echo 50

    pdf_islemi_calistir "$GIRIS_PDF" "$CIKIS_PDF" "$KALITE" >/dev/null 2>&1

    echo 90
    sleep 0.5
    echo 100
} | whiptail --gauge "PDF işleniyor, lütfen bekleyin..." 8 60 0

# --- 5. SONUÇ RAPORU ---
if [ -f "$CIKIS_PDF" ]; then
    ESKI_BYTE=$(stat -c%s "$GIRIS_PDF")
    YENI_BYTE=$(stat -c%s "$CIKIS_PDF")

    ESKI_FMT=$(numfmt --to=iec-i --suffix=B "$ESKI_BYTE")
    YENI_FMT=$(numfmt --to=iec-i --suffix=B "$YENI_BYTE")

    if [ "$ESKI_BYTE" -gt 0 ]; then
        ORAN=$(( 100 - (YENI_BYTE * 100 / ESKI_BYTE) ))
    else
        ORAN=0
    fi

    if [ "$YENI_BYTE" -gt "$ESKI_BYTE" ]; then
        MESAJ="PDF boyutu küçültülemedi, dosya boyutu arttı."
    else
        MESAJ="PDF başarıyla küçültüldü."
    fi

    whiptail --title "İşlem Sonucu" --msgbox \
"$MESAJ

Eski Boyut : $ESKI_FMT
Yeni Boyut : $YENI_FMT
Kazanç     : %$ORAN

Kayıt Yeri:
$CIKIS_PDF" \
20 70
else
    whiptail --title "Hata" \
    --msgbox "PDF oluşturulamadı. Ghostscript çalışmamış olabilir." 10 60
fi
