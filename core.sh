#!/bin/bash

# PDF boyutunu azaltmak için yardımcı fonksiyon
pdf_islemi_calistir() {
    local giris_dosyasi="$1"
    local cikis_dosyasi="$2"
    local kalite_secimi="$3"

    local gs_parametre

    if [ "$kalite_secimi" = "dusuk" ]; then
        gs_parametre="/screen"
    elif [ "$kalite_secimi" = "orta" ]; then
        gs_parametre="/ebook"
    elif [ "$kalite_secimi" = "yuksek" ]; then
        gs_parametre="/printer"
    else
        gs_parametre="/ebook"
    fi
	gs \
  	-sDEVICE=pdfwrite \
  	-dCompatibilityLevel=1.4 \
  	-dPDFSETTINGS="$gs_parametre" \
  	-dAutoRotatePages=/None \
  	-dNOPAUSE -dQUIET -dBATCH \
  	-sOutputFile="$cikis_dosyasi" \
  	"$giris_dosyasi"
}
