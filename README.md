# PDF Boyut Küçültme Aracı (GUI + TUI)

Bu proje, PARDUS Linux üzerinde çalışan, Ghostscript tabanlı bir PDF boyut küçültme ve optimizasyon aracıdır.
Bash Script ile geliştirilmiştir ve hem grafik arayüz (GUI) hem de terminal arayüzü (TUI) sunmaktadır.

## Projenin Amacı

Bu projenin amacı, Linux ortamında PDF dosyalarının boyutunu kullanıcı dostu bir şekilde küçültebilen,
modüler ve PARDUS uyumlu bir araç geliştirmektir.

Proje kapsamında hem grafik arayüz hem de terminal tabanlı arayüz kullanılarak
iki farklı kullanım senaryosu desteklenmiştir.

## Özellikler

- PDF dosyalarının boyutunu küçültme
- Üç farklı sıkıştırma seviyesi:
  - Düşük: En küçük dosya boyutu
  - Orta: Dengeli (önerilen)
  - Yüksek: En iyi kalite
- Grafik arayüz (YAD)
- Terminal arayüzü (Whiptail)
- İşlem sonrası detaylı raporlama
- Modüler kod yapısı

## Proje Yapısı

```
pdf_boyut_kucultme/
├── core.sh      # Ortak PDF sıkıştırma fonksiyonları
├── gui.sh       # Grafik arayüz (YAD)
├── tui.sh       # Terminal arayüzü (Whiptail)
├── README.md    # Proje dokümantasyonu
```

## Kullanılan Teknolojiler

- Bash Script
- Ghostscript
- YAD (Yet Another Dialog)
- Whiptail
- PARDUS Linux

## Gereksinimler

Projenin çalışabilmesi için aşağıdaki paketlerin sistemde kurulu olması gerekir:

- ghostscript
- yad
- whiptail

### Paket Kurulumu

```bash
sudo apt update
sudo apt install ghostscript yad whiptail -y
```

## Kurulum Adımları

1. Depoyu klonlayın:

```bash
git clone https://github.com/mlkyzgt/pdf_boyut_kucultme.git
```

2. Proje dizinine girin:

```bash
cd pdf_boyut_kucultme
```

3. Script dosyalarına çalıştırma izni verin:

```bash
chmod +x core.sh gui.sh tui.sh
```

## Kullanım

### Grafik Arayüz (GUI)

```bash
./gui.sh
```

Grafik arayüz üzerinden PDF dosyası seçilir ve sıkıştırma seviyesi belirlenir.

### Terminal Arayüzü (TUI)

```bash
./tui.sh
```

Terminal tabanlı menüler kullanılarak PDF dosya yolu ve sıkıştırma seviyesi girilir.

## Çalışma Mantığı

PDF sıkıştırma işlemleri core.sh dosyasında bulunan ortak fonksiyonlar aracılığıyla gerçekleştirilir.
GUI ve TUI arayüzleri yalnızca kullanıcıdan gerekli bilgileri almakta ve aynı çekirdek fonksiyonu kullanmaktadır.

Bu yapı sayesinde kod tekrarından kaçınılmış ve modüler bir mimari elde edilmiştir.

## PARDUS Uyumluluğu

Proje PARDUS Linux üzerinde geliştirilmiş ve test edilmiştir.
Bağımlılıklar doğru şekilde kurulduğunda sorunsuz çalışmaktadır.

## YouTube Linki

Projenin denemesinin yapıldığı YouTube videosuna  
[buradan](https://youtu.be/4toDfk44IuA?si=PGocnZVORRDCrOfQ) ulaşabilirsiniz.
