#!/bin/bash
# Contoh script menu sederhana

clear
echo "=============================="
echo "      Demo Menu via curl      "
echo "=============================="
echo "1. Sapa User"
echo "2. Info Tanggal"
echo "3. Keluar"
echo "------------------------------"
read -p "Pilih opsi [1-3]: " pilihan

case $pilihan in
  1)
    echo "Halo! Semoga harimu menyenangkan 😎"
    ;;
  2)
    echo "Hari ini: $(date)"
    ;;
  3)
    echo "Bye 👋"
    exit 0
    ;;
  *)
    echo "Pilihan tidak valid!"
    ;;
esac
