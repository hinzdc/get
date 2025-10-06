#!/bin/bash

# Skrip untuk mendeteksi nama pemasaran macOS

# Dapatkan string versi lengkap (contoh: "14.1.2" atau "10.15.7")
os_version=$(sw_vers -productVersion)

# Ekstrak nomor versi mayor dan minor
major_version=$(echo "$os_version" | cut -d. -f1)
minor_version=$(echo "$os_version" | cut -d. -f2)

os_name="Tidak dikenal"

# Tentukan nama pemasaran berdasarkan versi
if [ "$major_version" -ge 11 ]; then
    case "$major_version" in
        15) os_name="Sequoia" ;;
        14) os_name="Sonoma" ;;
        13) os_name="Ventura" ;;
        12) os_name="Monterey" ;;
        11) os_name="Big Sur" ;;
        *)  os_name="Versi setelah Big Sur (tidak dikenal)" ;;
    esac
elif [ "$major_version" -eq 10 ]; then
    case "$minor_version" in
        15) os_name="Catalina" ;;
        14) os_name="Mojave" ;;
        13) os_name="High Sierra" ;;
        12) os_name="Sierra" ;;
        11) os_name="El Capitan" ;;
        10) os_name="Yosemite" ;;
        *)  os_name="Versi sebelum Yosemite" ;;
    esac
else
    os_name="Versi macOS sangat lama atau tidak dikenal"
fi
echo "macOS $os_name $os_version"
