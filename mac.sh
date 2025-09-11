#!/bin/bash

# URL installer untuk masing-masing versi Office
OFFICE_RESET="https://office-reset.com/download/Microsoft_Office_Reset_2.0.0.pkg"
OFFICE_2016="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_2016_VL_Serializer_2.0.pkg"
OFFICE_2019="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_2019_VL_Serializer_Universal.pkg"
OFFICE_2021="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_LTSC_2021_VL_Serializer.pkg"
OFFICE_2024="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_LTSC_2024_VL_Serializer.pkg"

# Fungsi untuk download & install
install_pkg() {
    local url=$1
    local filename="/tmp/$(basename "$url")"

    echo "Mengunduh dari: $url ..."
    curl -L --progress-bar "$url" -o "$filename"


    if [[ -f "$filename" ]]; then
        echo "Download selesai: $filename"
        echo "Menjalankan installer (memerlukan password admin)..."
        echo "Ingin jalankan installer dengan GUI (g) atau Silent (s)? [default s]: "
        read mode
        mode=${mode:-s}

        if [[ "$mode" == "g" ]]; then
            echo "Menjalankan installer dalam mode GUI..."
            open "$filename"
        else
            echo "Menjalankan installer dalam mode silent (terminal)..."
            sudo installer -pkg "$filename" -target /
        fi

    else
        echo "Gagal mengunduh file!"
    fi
}

# Sub-menu Aktivasi Office
submenu_office() {
    while true; do
        clear
        echo "=============================="
        echo "     Aktivasi Office Menu     "
        echo "=============================="
        echo "1. Office 2016"
        echo "2. Office 2019"
        echo "3. Office 2021"
        echo "4. Office 2024"
        echo "5. Office Reset"
        echo "6. Kembali ke Menu Utama"
        echo "------------------------------"
        echo -n "Pilih versi [1-5] (default 5): "
        read subpilih
        subpilih=${subpilih:-5}

        case $subpilih in
            1) install_pkg "$OFFICE_2016" ;;
            2) install_pkg "$OFFICE_2019" ;;
            3) install_pkg "$OFFICE_2021" ;;
            4) install_pkg "$OFFICE_2024" ;;
            5) install_pkg "$OFFICE_RESET" ;;
            6) return ;; # balik ke menu utama
            *) echo "Pilihan tidak valid!" ;;
        esac

        echo
        read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali ke Sub-Menu Office..."
    done
}

submenu_tools() {
    while true; do
        clear
        echo "=============================="
        echo "          Tools Menu     "
        echo "=============================="
        echo "1. Mist"
        echo "2. Bombardier"
        echo "3. Sentinel"
        echo "4. Office 2024"
        echo "5. Office Reset"
        echo "6. Kembali ke Menu Utama"
        echo "------------------------------"
        echo -n "Pilih versi [1-5] (default 5): "
        read subpilih
        subpilih=${subpilih:-5}

        case $subpilih in
            1) install_pkg "$OFFICE_2016" ;;
            2) install_pkg "$OFFICE_2019" ;;
            3) install_pkg "$OFFICE_2021" ;;
            4) install_pkg "$OFFICE_2024" ;;
            5) install_pkg "$OFFICE_RESET" ;;
            6) return ;; # balik ke menu utama
            *) echo "Pilihan tidak valid!" ;;
        esac

        echo
        read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali ke Sub-Menu Office..."
    done
}


# Menu utama
while true; do
    clear
    echo "=============================="
    echo "      AURORATOOLKIT MENU      "
    echo "=============================="
    echo "1. Aktivasi Office"
    echo "2. Tools"
    echo "3. Keluar"
    echo "------------------------------"
    echo -n "Pilih opsi [1-3] (default 1): "
    read pilihan
    pilihan=${pilihan:-1}

    case $pilihan in
      1) submenu_office ;;  # masuk ke sub-menu Office
      2) echo "Hari ini: $(date)" ;;
      3) echo "Bye 👋"; exit 0 ;;
      *) echo "Pilihan tidak valid!" ;;
    esac

    echo
    read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali ke menu..."
done
