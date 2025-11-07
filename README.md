![](https://vbr.nathanchung.dev/badge?page_id=hinzdc-get&color=55acb7&style=for-the-badge&logo=Github)

## GET

## Ringkasan
Repositori ini berisi kumpulan skrip otomatisasi untuk Windows dan Office yang membantu proses aktivasi, pemeliharaan sistem, hingga pembersihan malware. Isi repositori menggabungkan skrip batch (`.bat`), PowerShell (`.ps1`), serta berkas pendukung lain yang dapat dijalankan langsung ataupun diunduh otomatis melalui skrip utama.

## Struktur Direktori Penting
| Folder / Berkas | Deskripsi Singkat |
| --- | --- |
| `cmd/` | Skrip batch utama untuk aktivasi Windows/Office, manajemen host, penghapusan aplikasi bawaan, dan utilitas lain. |
| `active*` | Sekumpulan skrip PowerShell yang mengunduh dan menjalankan skrip aktivasi terkait dari folder `cmd`. |
| `office/`, `installoffice/` | Installer, konfigurasi, dan otomatisasi terkait pemasangan Microsoft Office. |
| `officescrub*/` | Skrip pembersihan instalasi Office untuk memastikan instalasi ulang yang bersih. |
| `windowsupdate/`, `disablewu/`, `enablewu/`, `resetwindowsupdate/`, `pausewu/` | Alat untuk mengelola layanan Windows Update (menonaktifkan, mengaktifkan, menjeda, atau mereset). |
| `ForceRemove/`, `virusremoval*/`, `WindowsLoginUnlocker.bat` | Utilitas pemecahan masalah dan pembersihan malware secara cepat. |
| `install-choco/`, `winget/`, `appx*/`, `removeappx/` | Skrip untuk mengelola paket aplikasi melalui Chocolatey, Winget, ataupun AppX. |
| `mac/`, `mac.sh`, `getmacosname.sh` | Skrip shell yang berkaitan dengan penentuan nama/macOS (khusus lingkungan non-Windows). |
| `README.md` | Lencana status repositori. |

## Cara Menggunakan
1. **Unduh repositori** atau buka melalui Git: `git clone https://github.com/hinzdc/get.git`.
2. **Pilih skrip yang diperlukan** sesuai kategori di atas.
3. **Jalankan sebagai Administrator** pada Windows (klik kanan → *Run as administrator* untuk `.bat` / `.cmd`, atau buka PowerShell dengan hak admin sebelum menjalankan `.ps1`).
4. Ikuti instruksi yang muncul pada terminal; beberapa skrip akan mengunduh berkas tambahan dari repositori ini secara otomatis.

## Catatan dan Peringatan
- Skrip aktivasi dapat melibatkan perubahan lisensi yang mungkin tidak sesuai dengan kebijakan organisasi atau vendor; gunakan secara bertanggung jawab.
- Matikan antivirus atau *SmartScreen* hanya bila diperlukan dan pastikan Anda mempercayai sumber skrip.
- Lakukan pencadangan sebelum menjalankan skrip pembersihan atau modifikasi sistem agar dapat melakukan *rollback* jika terjadi masalah.
