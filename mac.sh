#!/bin/bash

# URL installer untuk masing-masing versi Office
ACT_OFFICE_LICENSE_REMOVAL_TOOL="https://go.microsoft.com/fwlink/?linkid=849815"
ACT_OFFICE_RESET="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_Reset_2.0.0.pkg"
ACT_OFFICE_2016="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_2016_VL_Serializer_2.0.pkg"
ACT_OFFICE_2019="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_2019_VL_Serializer_Universal.pkg"
ACT_OFFICE_2021="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_LTSC_2021_VL_Serializer.pkg"
ACT_OFFICE_2024="https://github.com/alsyundawy/Microsoft-Office-For-MacOS/raw/refs/heads/master/DATA/Microsoft_Office_LTSC_2024_VL_Serializer.pkg"
INSTALL_OFFICE_2016_YOSEMITE="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.16.20101200_Installer.pkg" #Yosemite
INSTALL_OFFICE_2019_SIERRA="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.43.20110804_Installer.pkg" #Sierra
INSTALL_OFFICE_2019_HIGHSIERRA="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.43.20110804_Installer.pkg" # High Sierra
INSTALL_OFFICE_2019_MOJAVE="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.54.21101001_Installer.pkg" #Mojave
INSTALL_OFFICE_2019_2021_CATALINA="https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.66.22101101_Installer.pkg" #Catalina
INSTALL_OFFICE_2019_2021_BIGSURE="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_365_and_Office_16.77.23091003_Installer.pkg" # Big Sur
INSTALL_OFFICE_2019_2021_MONTEREY="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_365_and_Office_16.78.23102801_Installer.pkg" # Monterey dan Big Sur
INSTALL_OFFICE_2021_2024_VENTURA="https://go.microsoft.com/fwlink/?linkid=525133" # Ventura dan lebih baru
MIST="https://github.com/ninxsoft/Mist/releases/download/v0.30/Mist.0.30.pkg"
BOMBARDIER="https://github.com/ninxsoft/Bombardier/releases/download/v3.0/Bombardier.3.0.pkg"
SETINEL_INTEL="https://github.com/alienator88/Sentinel/releases/download/3.1.3/Sentinel-intel.zip"
SETINEL_ARM="https://github.com/alienator88/Sentinel/releases/download/3.1.3/Sentinel-arm.zip"
PEARCLEANER="https://github.com/alienator88/Pearcleaner/releases/download/5.2.1/Pearcleaner.dmg"
ADOBE_CC_CLEANER="https://swupmf.adobe.com/webfeed/CleanerTool/mac/AdobeCreativeCloudCleanerTool.dmg"
APP_CLEANER="https://freemacsoft.net/downloads/AppCleaner_3.6.8.zip"
THE_UNARCHIVER="https://dl.devmate.com/com.macpaw.site.theunarchiver/TheUnarchiver.dmg"
KEKA="https://d.keka.io/"
STATS="https://github.com/exelban/stats/releases/download/v2.11.56/Stats.dmg"
HOMEBREW_INSTALL_COMMAND='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
# Fungsi utama untuk mengunduh dan menangani file
handle_file() {
    local start_time=$(date +%s)
    local url=$1
    # Jika URL kosong, keluar
    if [[ -z "$url" ]]; then
        echo "URL tidak tersedia untuk item ini."
        return
    fi

    echo -e "\n⚙️  Menganalisis link unduhan..."
    # Dapatkan nama file asli dari header Content-Disposition
    header_info=$(curl -sIL "$url")
    content_disp=$(echo "$header_info" | grep -i "content-disposition")
    remote_filename=$(echo "$content_disp" | sed -n 's/.*filename=//p' | tr -d '\r' | tr -d '"')

    # Jika nama file dari header tidak ada, gunakan basename dari URL
    if [[ -n "$remote_filename" ]]; then
        echo "✅ Link redirect terdeteksi. Nama file asli: $remote_filename"
        final_filename="$remote_filename"
    else
        final_filename=$(basename "$url")
        echo "✅ Link langsung terdeteksi. Nama file: $final_filename"
    fi

    local tmp_file="/tmp/$final_filename"
    
    echo
    echo " >> Mengunduh $final_filename..."
    # Opsi -f untuk gagal diam-diam jika ada error server (spt 404)
    curl -fL --progress-bar "$url" -o "$tmp_file"

    # Cek apakah unduhan berhasil
    if [[ ! -f "$tmp_file" ]]; then
        echo "❌ Gagal mengunduh file! Pastikan URL benar dan koneksi internet stabil."
        return 1
    fi

    echo "✅ Unduhan selesai: $tmp_file"
    
    # Cek ekstensi file
    local extension="${tmp_file##*.}"

    case "$extension" in
        pkg)
            echo
            echo "File .pkg terdeteksi. Pilih cara instalasi:"
            echo ""
            echo " [1] Mode GUI (Buka installer)"
            echo " [2] Mode Silent (Perlu password admin)"
            echo ""
            echo -n "Masukkan pilihan [1-2] (default 1): "
            read -r mode
            mode=${mode:-1}

            if [[ "$mode" == "1" ]]; then
                echo "🚀 Menjalankan installer dalam mode GUI..."
                open -W "$tmp_file"
            else
                echo "⚙️  Menjalankan installer dalam mode Silent..."
                echo "Proses ini bisa memakan waktu beberapa menit dan tidak akan menampilkan output."
                echo "Harap tunggu hingga skrip memberikan notifikasi selesai."
                sudo installer -pkg "$tmp_file" -target / > /dev/null 2>&1
            fi
            
            if [[ $? -eq 0 ]]; then
                echo "✅ Instalasi selesai!"
            else
                echo "⚠️  Proses instalasi selesai dengan kemungkinan error."
            fi
            ;;
        zip)
            local extract_dir="$HOME/Downloads/$(basename "$tmp_file" .zip)"
            echo "File .zip terdeteksi. Mengekstrak ke: $extract_dir"
            mkdir -p "$extract_dir"
            unzip -o "$tmp_file" -d "$extract_dir"
            if [[ $? -eq 0 ]]; then
                echo "✅ Ekstraksi selesai."
                local app_path=$(find "$extract_dir" -name "*.app" -maxdepth 2 | head -n 1)
                if [[ -n "$app_path" ]]; then
                    local app_name=$(basename "$app_path")
                    local dest_path="/Applications/$app_name"
                    echo "Aplikasi ditemukan: $app_name"

                    if [ -d "$dest_path" ]; then
                        echo -n "⚠️  Aplikasi '$app_name' sudah ada. Ganti? (y/N): "
                        read -r replace_confirm
                        if [[ "$replace_confirm" =~ ^[Yy]$ ]]; then
                            echo "⚙️  Memindahkan versi baru ke /Applications... (Mungkin perlu password)"
                            sudo mv -f "$app_path" "/Applications/"
                        else
                            echo "❌ Instalasi dibatalkan."
                            # Hapus folder ekstraksi karena tidak jadi diinstal
                            rm -rf "$extract_dir"
                            return
                        fi
                    else
                        echo "⚙️  Memindahkan aplikasi ke /Applications... (Mungkin perlu password)"
                        sudo mv "$app_path" "/Applications/"
                    fi

                    if [ -d "$dest_path" ]; then
                        echo "✅ Aplikasi berhasil diinstal di $dest_path"
                        # Hapus sisa folder ekstraksi yg kosong
                        rm -rf "$extract_dir"
                        echo "🚀 Membuka aplikasi..."
                        open -F -n "$dest_path"
                    else
                        echo "❌ Gagal memindahkan aplikasi ke /Applications."
                    fi
                else
                    echo "Tidak ada file .app yang ditemukan. Membuka folder di Finder..."
                    open "$extract_dir"
                fi
            else
                echo "❌ Gagal mengekstrak file zip."
            fi
            ;;
        dmg)
            echo "File .dmg terdeteksi. Memasang (mounting) image..."
            mount_output=$(hdiutil attach "$tmp_file")
            if [[ $? -eq 0 ]]; then
                local mount_point=$(echo "$mount_output" | grep -o "/Volumes/.*" | head -n 1)
                echo "✅ DMG berhasil dipasang di: $mount_point"
                
                local app_path=$(find "$mount_point" -name "*.app" -maxdepth 2 | head -n 1)
                if [[ -n "$app_path" ]]; then
                    local app_name=$(basename "$app_path")
                    local dest_path="/Applications/$app_name"
                    echo "Aplikasi ditemukan: $app_name"

                    if [ -d "$dest_path" ]; then
                        echo -n "⚠️  Aplikasi '$app_name' sudah ada. Ganti? (y/N): "
                        read -r replace_confirm
                        if [[ ! "$replace_confirm" =~ ^[Yy]$ ]]; then
                            echo "❌ Instalasi dibatalkan."
                            # Langsung ke proses unmount
                            app_path=""
                        fi
                    fi

                    if [[ -n "$app_path" ]]; then
                        echo "⚙️  Menyalin aplikasi ke /Applications... (Mungkin perlu password)"
                        sudo cp -R "$app_path" "/Applications/"
                        if [ -d "$dest_path" ]; then
                            echo "✅ Aplikasi berhasil diinstal di $dest_path"
                            echo "🚀 Membuka aplikasi..."
                            open -F -n "$dest_path"
                        else
                            echo "❌ Gagal menyalin aplikasi ke /Applications."
                        fi
                    fi
                else
                    echo "Tidak ada file .app yang ditemukan. Membuka volume di Finder..."
                    open "$mount_point"
                fi

                echo
                read -n 1 -s -r -p "Tekan ENTER untuk melepaskan (unmount) DMG..."
                echo
                echo "⚙️ Melepaskan DMG..."
                hdiutil detach "$mount_point" -force
            else
                echo "❌ Gagal memasang file DMG."
            fi
            ;;
        *)
            echo "Unsupported file type: $extension"
            echo "File tersimpan di $tmp_file"
            ;;
    esac

    echo "🧹 Membersihkan file sementara..."
    rm "$tmp_file"
    echo

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    echo "✅ Proses selesai dalam $minutes menit $seconds detik."
}

submenu_installoffice_manual() {
    clear
    echo "=================================="
    echo "     Pilih Versi Office Manual"
    echo "=================================="
    
    local manual_options=(
        "Office 2021/2024 (Ventura+)"
        "Office 2019/2021 (Monterey)"
        "Office 2019/2021 (Big Sur)"
        "Office 2019/2021 (Catalina)"
        "Office 2019 (Mojave)"
        "Office 2019 (High Sierra)"
        "Office 2019 (Sierra)"
        "Office 2016 (Yosemite)"
    )
    local manual_urls=(
        "$INSTALL_OFFICE_2021_2024_VENTURA"
        "$INSTALL_OFFICE_2019_2021_MONTEREY"
        "$INSTALL_OFFICE_2019_2021_BIGSURE"
        "$INSTALL_OFFICE_2019_2021_CATALINA"
        "$INSTALL_OFFICE_2019_MOJAVE"
        "$INSTALL_OFFICE_2019_HIGHSIERRA"
        "$INSTALL_OFFICE_2019_SIERRA"
        "$INSTALL_OFFICE_2016_YOSEMITE"
    )

    for i in "${!manual_options[@]}"; do
        echo "[$((i+1))] ${manual_options[$i]}"
    done
    echo "[0] Kembali"
    echo
    echo -n "Pilih versi untuk diinstal: "
    read -r manual_choice

    if [[ "$manual_choice" == "0" ]]; then
        return
    elif [[ "$manual_choice" -gt 0 && "$manual_choice" -le ${#manual_options[@]} ]]; then
        local selected_url=${manual_urls[$((manual_choice-1))]}
        handle_file "$selected_url"
    else
        echo "Pilihan tidak valid!"
    fi
}

submenu_installoffice() {
    local os_version_full=$(sw_vers -productVersion)
    local os_version_major=$(echo "$os_version_full" | cut -d. -f1)
    local os_version_minor=$(echo "$os_version_full" | cut -d. -f2)

    local url_to_install=""
    local os_name=""

    # Deteksi OS berdasarkan versi
    case $os_version_major in
        26) Tahoe
            os_name="Tahoe"
            url_to_install=$INSTALL_OFFICE_2021_2024_VENTURA
            ;;
        15) #Sequoia
            os_name="Sequoia"
            url_to_install=$INSTALL_OFFICE_2021_2024_VENTURA
            ;;
        14) # Sonoma
            os_name="Sonoma"
            url_to_install=$INSTALL_OFFICE_2021_2024_VENTURA
            ;;
        13) # Ventura
            os_name="Ventura"
            url_to_install=$INSTALL_OFFICE_2021_2024_VENTURA
            ;;
        12) # Monterey
            os_name="Monterey"
            url_to_install=$INSTALL_OFFICE_2019_2021_MONTEREY
            ;;
        11) # Big Sur
            os_name="Big Sur"
            url_to_install=$INSTALL_OFFICE_2019_2021_BIGSURE
            ;;
        10) # OS X
            case $os_version_minor in
                15) os_name="Catalina"; url_to_install=$INSTALL_OFFICE_2019_2021_CATALINA ;;
                14) os_name="Mojave"; url_to_install=$INSTALL_OFFICE_2019_MOJAVE ;;
                13) os_name="High Sierra"; url_to_install=$INSTALL_OFFICE_2019_HIGHSIERRA ;;
                12) os_name="Sierra"; url_to_install=$INSTALL_OFFICE_2019_SIERRA ;;
                10) os_name="Yosemite"; url_to_install=$INSTALL_OFFICE_2016_YOSEMITE ;;
                *) os_name="Unsupported OS X" ;;
            esac
            ;;
        *)
            os_name="Unknown"
            ;;
    esac

    clear
    echo "=================================="
    echo "        Install Office Menu"
    echo "=================================="
    echo "macOS $os_name $os_version_full terdeteksi."
    echo

    if [[ -n "$url_to_install" ]]; then
        echo "Versi Office yang direkomendasikan untuk OS Anda telah ditemukan."
        echo
        echo "[1] Install Versi Rekomendasi"
        echo "[2] Pilih Versi Lain (Manual)"
        echo "[0] Kembali ke Menu Utama"
        echo
        echo -n "Pilih opsi [1, 2, 0]: "
        read -r choice

        case $choice in
            1)
                handle_file "$url_to_install"
                ;;
            2)
                submenu_installoffice_manual
                ;;
            0)
                return
                ;;
            *)
                echo "Pilihan tidak valid!"
                ;;
        esac
    else
        echo "Tidak ada versi rekomendasi untuk OS Anda. Silakan pilih dari daftar manual."
        sleep 2
        submenu_installoffice_manual
    fi

    echo
    read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu utama..."
}

submenu_installapps() {
    echo
    echo "Fitur ini sedang dalam pengembangan."
    echo "Silakan kembali lagi nanti."
    read -n 1 -s -r -p "Tekan ENTER untuk kembali..."
}

submenu_poweruser() {
    while true; do
        clear
        echo "=============================="
        echo "      Power User Tools Menu     "
        echo "=============================="
        echo "Homebrew adalah package manager esensial untuk macOS."
        echo
        echo "[1] Install Homebrew"
        echo "[0] Kembali ke Menu Utama"
        echo "------------------------------"
        echo -n "Pilih opsi: "
        read -r choice

        case $choice in
            1)
                echo
                echo "Perintah instalasi Homebrew akan dijalankan."
                echo "Ini akan mengunduh dan menjalankan skrip dari situs resmi Homebrew."
                echo -n "Lanjutkan? (y/N): "
                read -r confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    echo "Menjalankan installer Homebrew..."
                    eval "$HOMEBREW_INSTALL_COMMAND"
                else
                    echo "Instalasi dibatalkan."
                fi
                ;;
            0)
                return
                ;;
            *)
                echo "Pilihan tidak valid!"
                ;;
        esac
        echo
        read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali..."
    done
}

# Sub-menu Aktivasi Office
submenu_activeoffice() {
    while true; do
        clear
        echo " ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗"
        echo " ║                                                       ║"
        echo " ║                  ACTIVATION OFFICE                    ║"
        echo " ║                                                       ║"
        echo " ╠╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╣"
        echo " ║                                                       ║"
        echo " ║ [1] Office 2011                                       ║"
        echo " ║ [2] Office 2016                                       ║"
        echo " ║ [3] Office 2019                                       ║"
        echo " ║ [4] Office 2021                                       ║"
        echo " ║ [5] Office 2024                                       ║"
        echo " ║ [6] Office Reset                                      ║"
        echo " ║ [7] License Removal Tool                              ║"
        echo " ║ [0] Back to menu                                      ║"
        echo " ║                                                       ║"
        echo " ║  ╔══════════════════════╗                             ║"
        echo " ╚══╣ Input Option [1-7]:  ╠═════════════════════════════╝"
        echo "    ╚══════════════════════╝"
        echo -n "     >>"
        read -n 1 subpilih

        case $subpilih in
            1) echo -e "\n\n Pilih salah satu serial number di bawah dan masukan di office 2011.." ;
               echo -e "╔═══════════════════════════════╗\n" ;
               echo -e "  2WBVT-PTKRB-2RH2B-X2DYY-QBXP4" ;
               echo -e "  V22QX-RC6F3-CMWP7-WV6DH-K29P7" ;
               echo -e "  KCDHJ-KGTKV-788PG-WVBQT-GRWX8" ;
               echo -e "  4FVWX-W7Q37-GKYMW-JDWWR-89763" ;
               echo -e "  6JTF2-PM3PD-62WQY-TBC3V-H7KKC" ;
               echo -e "  4D484-GT8D2-CMR2M-WBJ49-GWFTD" ;
               echo -e "  KB3V9-3T4X4-32YR6-MX62Q-CVMK4" ;
               echo -e "  YPWTM-X3QR3-QHV8Q-9QH9H-RMHX3" ;
               echo -e "  C7TTK-M29H8-9H7JR-P82WG-2DCDW\n" ;
               echo "╚═══════════════════════════════╝" ;;
            2) handle_file "$ACT_OFFICE_2016" ;;
            3) handle_file "$ACT_OFFICE_2019" ;;
            4) handle_file "$ACT_OFFICE_2021" ;;
            5) handle_file "$ACT_OFFICE_2024" ;;
            6) handle_file "$ACT_OFFICE_RESET" ;;
            7) handle_file "$ACT_OFFICE_LICENSE_REMOVAL_TOOL" ;;
            0) return ;;
            *) echo "Pilihan tidak valid!" ;;
        esac

        echo
        read -n 1 -s -r -p "Tekan ENTER untuk kembali..."
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
        echo "4. PearCleaner"
        echo "5. Office Reset"
        echo "6. Adobe CC Cleaner Tool"
        echo "7. AppCleaner"
        echo "8. The Unarchiver"
        echo "9. Keka File Archiver"
        echo "10. Stats System Monitor"
        echo "0. Kembali ke Menu Utama"
        echo "------------------------------"
        echo -n "Pilih opsi: "
        read -r subpilih

        case $subpilih in
            1) handle_file "$MIST" ;;
            2) handle_file "$BOMBARDIER" ;;
            3) 
                echo "Mendeteksi arsitektur..."
                if [[ "$(uname -m)" == "arm64" ]]; then
                    echo "Apple Silicon (ARM) terdeteksi."
                    handle_file "$SETINEL_ARM"
                else
                    echo "Intel terdeteksi."
                    handle_file "$SETINEL_INTEL"
                fi
                ;;
            4) handle_file "$PEARCLEANER" ;;
            5) handle_file "$ACT_OFFICE_RESET" ;;
            6) handle_file "$ADOBE_CC_CLEANER" ;;
            7) handle_file "$APP_CLEANER" ;;
            8) handle_file "$THE_UNARCHIVER" ;;
            9) handle_file "$KEKA" ;;
            10) handle_file "$STATS" ;;
            0) return ;; # balik ke menu utama
            *) echo "Pilihan tidak valid!" ;;
        esac

        echo
        read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali..."
    done
}


# Menu utama
while true; do
    clear
    echo
    echo " ╔╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╗"
    echo " ║                                                       ║"
    echo " ║    ██                                   ██            ║"
    echo " ║    ██▒▒█████ ██ ██████▒▒ ███████  ████▒▒██ ▒▒█████    ║"
    echo " ║    ██     ██          ██    ▒▒██  ██    ██ ██         ║"
    echo " ║    ██     ██ ██ ██    ██ ▒▒██     ██    ██ ██         ║"
    echo " ║    ██     ██ ██ ██    ██ ███████  ████████ ▒▒█████    ║"
    echo " ║                                                       ║"
    echo " ╚═══════════════════════════════════════════════════════╝"
    echo " ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗"
    echo " ║                                                       ║"
    echo " ║                  AURORATOOLKIT MENU                   ║"
    echo " ║                                                       ║"
    echo " ╠╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╣"
    echo " ║ [1] Aktivasi Microsoft Office                         ║"
    echo " ║ [2] Tools                                             ║"
    echo " ║ [3] Install Office                                    ║"
    echo " ║ [4] Install Aplikasi (Dalam Pengembangan)             ║"
    echo " ║ [5] Power User Tools                                  ║"
    echo " ║ [0] Keluar                                            ║"
    echo " ╚═══════════════════════════════════════════════════════╝"
    echo
    echo -n ">>Pilih opsi [1-5, 0]: "
    read -n 1 pilihan

    case $pilihan in
      1) submenu_activeoffice ;;
      2) submenu_tools ;;
      3) submenu_installoffice ;;
      4) submenu_installapps ;;
      5) submenu_poweruser ;;
      0) echo -e "\n    Bye.. 👋"; exit 0 ;;
      *) echo "Pilihan tidak valid!" ;;
    esac

    echo
    #read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali ke menu..."
done
