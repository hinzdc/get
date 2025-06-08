@echo off
setlocal enabledelayedexpansion
title Hosts Blocker For Online Activation v1.0
mode con cols=90 lines=29
color 0B
:Begin UAC check and Auto-Elevate Permissions
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo:
echo   Requesting Administrative Privileges...
echo   Press YES in UAC Prompt to Continue
echo:

    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

cls

:menu
cls
color 0B
echo ^> hinzdc
echo                                                   �����������������������������ͻ
echo          ����������������������������������������Ϲ ISTANA BEC LANTAI 1 BLOK D7 �
echo          �                                        �����������������������������ѹ
echo          �   ��                                ��                               �
echo          �   �� �����۱� �������� �������      �� �������� ��     �� ��������   �
echo          �   ��       �� ��   ��� ��   ��      �� ��    �� ��     �� ��    ��   �
echo          �   �� ��    �� ��   ��� ��   �� ��   �� �������� ���   ��� ��������   �
echo          �   �� ��    �� �������� ������� ������� ��    ��    ���    ��    ��   �
echo          �                                                                      �
echo          ����������������������������������������������������������������������Ѽ
powershell "write-host -fore 'Red' '                        -- HOST FILE TO BLOCK ONLINE ACTIVATION --'
echo ------------------------------------------------------------------------------------------
echo  PILIH APLIKASI:
echo.
echo  [1] Adobe
echo  [2] Autodesk
echo  [3] Wondershare
echo  [4] Lumion
echo  [5] Corel
echo  [6] Acronis
echo  [7] MiniTool
echo  [8] Keluar
echo  [e] Edit manual hosts file
echo.
echo ------------------------------------------------------------------------------------------
choice /c 12345678e /n /m " Masukkan Pilihan Anda (1-9): "

if "%errorlevel%"=="1" goto adobe
if "%errorlevel%"=="2" goto autodesk
if "%errorlevel%"=="3" goto wondershare
if "%errorlevel%"=="4" goto lumion
if "%errorlevel%"=="5" goto corel
if "%errorlevel%"=="6" goto acronis
if "%errorlevel%"=="7" goto minitool
if "%errorlevel%"=="8" goto keluar
if "%errorlevel%"=="9" goto edithost

echo.
powershell "write-host -fore 'Red' ' Pilihan tidak valid, coba lagi.'
timeout /t 5 >nul
goto menu

:adobe
set domains=192.150.14.69 192.150.18.101 192.150.18.108 192.150.22.40 192.150.8.100 192.150.8.118 199.7.52.190:80 199.7.52.190 199.7.54.72:80 199.7.54.72 209.34.83.67:43 209.34.83.67:443 209.34.83.67 209.34.83.73:43 209.34.83.73:443 209.34.83.73 209-34-83-73.ood.opsource.net 3dns.adobe.com 3dns-1.adobe.com 3dns-2.adobe.com 3dns-2.adobe.de 3dns-3.adobe.com 3dns-3.adobe.de 3dns-4.adobe.com 3dns-5.adobe.com activate.adobe.de activate.wip.adobe.com activate.wip1.adobe.com activate.wip2.adobe.com activate.wip3.adobe.com activate.wip3.adobe.de activate.wip4.adobe.com activate-sea.adobe.com activate-sea.adobe.de activate-sjc0.adobe.com activate-sjc0.adobe.de adobe.activate.com adobe-dns.adobe.com adobe-dns.adobe.de adobe-dns-1.adobe.com adobe-dns-2.adobe.com adobe-dns-2.adobe.de adobe-dns-3.adobe.com adobe-dns-3.adobe.de adobe-dns-4.adobe.com adobe-dns-5.adobe.com adobeereg.com cmdls.adobe.com ereg.adobe.com ereg.adobe.de ereg.wip.adobe.com ereg.wip1.adobe.com ereg.wip2.adobe.com ereg.wip3.adobe.com ereg.wip3.adobe.de ereg.wip4.adobe.com genuine.adobe.com hh-software.com hl2rcv.adobe.com hl2rcv.adobe.de hlrcv.stage.adobe.com ims-na1-prprod.adobelogin.com lm.licenses.adobe.com lmlicenses.wip.adobe.com lmlicenses.wip1.adobe.com lmlicenses.wip2.adobe.com lmlicenses.wip3.adobe.com lmlicenses.wip4.adobe.com na1r.services.adobe.com na2m-pr.licenses.adobe.com na2m-stg2.licenses.adobe.com na4r.services.adobe.com ocsp.spo1.verisign.com ood.opsource.net practivate.adobe.com practivate.adobe.de practivate.adobe.ipp practivate.adobe.newoa practivate.adobe.ntp practivate.adobe prod-rel-ffc-ccm.oobesaas.adobe.com s-2.adobe.com s-3.adobe.com t3dns.adobe.com tpractivate.adobe.newoa tss-geotrust-crl.thawte.com uds.licenses.adobe.com wip.adobe.com wip1.adobe.com wip2.adobe.com wip3.adobe.com wip3.adobe.de wip4.adobe.com wwis-dubc1-vip100.adobe.com wwis-dubc1-vip101.adobe.com wwis-dubc1-vip102.adobe.com wwis-dubc1-vip103.adobe.com wwis-dubc1-vip104.adobe.com wwis-dubc1-vip105.adobe.com wwis-dubc1-vip106.adobe.com wwis-dubc1-vip107.adobe.com wwis-dubc1-vip108.adobe.com wwis-dubc1-vip109.adobe.com wwis-dubc1-vip110.adobe.com wwis-dubc1-vip111.adobe.com wwis-dubc1-vip112.adobe.com wwis-dubc1-vip113.adobe.com wwis-dubc1-vip114.adobe.com wwis-dubc1-vip115.adobe.com wwis-dubc1-vip116.adobe.com wwis-dubc1-vip117.adobe.com wwis-dubc1-vip118.adobe.com wwis-dubc1-vip119.adobe.com wwis-dubc1-vip120.adobe.com wwis-dubc1-vip121.adobe.com wwis-dubc1-vip122.adobe.com wwis-dubc1-vip123.adobe.com wwis-dubc1-vip124.adobe.com wwis-dubc1-vip125.adobe.com wwis-dubc1-vip30.adobe.com wwis-dubc1-vip31.adobe.com wwis-dubc1-vip32.adobe.com wwis-dubc1-vip33.adobe.com wwis-dubc1-vip34.adobe.com wwis-dubc1-vip35.adobe.com wwis-dubc1-vip36.adobe.com wwis-dubc1-vip37.adobe.com wwis-dubc1-vip38.adobe.com wwis-dubc1-vip39.adobe.com wwis-dubc1-vip40.adobe.com wwis-dubc1-vip41.adobe.com wwis-dubc1-vip42.adobe.com wwis-dubc1-vip43.adobe.com wwis-dubc1-vip44.adobe.com wwis-dubc1-vip45.adobe.com wwis-dubc1-vip46.adobe.com wwis-dubc1-vip47.adobe.com wwis-dubc1-vip48.adobe.com wwis-dubc1-vip49.adobe.com wwis-dubc1-vip50.adobe.com wwis-dubc1-vip51.adobe.com wwis-dubc1-vip52.adobe.com wwis-dubc1-vip53.adobe.com wwis-dubc1-vip54.adobe.com wwis-dubc1-vip55.adobe.com wwis-dubc1-vip56.adobe.com wwis-dubc1-vip57.adobe.com wwis-dubc1-vip58.adobe.com wwis-dubc1-vip59.adobe.com wwis-dubc1-vip60.adobe.com wwis-dubc1-vip60.adobe.de wwis-dubc1-vip61.adobe.com wwis-dubc1-vip62.adobe.com wwis-dubc1-vip63.adobe.com wwis-dubc1-vip64.adobe.com wwis-dubc1-vip65.adobe.com wwis-dubc1-vip66.adobe.com wwis-dubc1-vip67.adobe.com wwis-dubc1-vip68.adobe.com wwis-dubc1-vip69.adobe.com wwis-dubc1-vip70.adobe.com wwis-dubc1-vip71.adobe.com wwis-dubc1-vip72.adobe.com wwis-dubc1-vip73.adobe.com wwis-dubc1-vip74.adobe.com wwis-dubc1-vip75.adobe.com wwis-dubc1-vip76.adobe.com wwis-dubc1-vip77.adobe.com wwis-dubc1-vip78.adobe.com wwis-dubc1-vip79.adobe.com wwis-dubc1-vip80.adobe.com wwis-dubc1-vip81.adobe.com wwis-dubc1-vip82.adobe.com wwis-dubc1-vip83.adobe.com wwis-dubc1-vip84.adobe.com wwis-dubc1-vip85.adobe.com wwis-dubc1-vip86.adobe.com wwis-dubc1-vip87.adobe.com wwis-dubc1-vip88.adobe.com wwis-dubc1-vip89.adobe.com wwis-dubc1-vip90.adobe.com wwis-dubc1-vip91.adobe.com wwis-dubc1-vip92.adobe.com wwis-dubc1-vip93.adobe.com wwis-dubc1-vip94.adobe.com wwis-dubc1-vip95.adobe.com wwis-dubc1-vip96.adobe.com wwis-dubc1-vip97.adobe.com wwis-dubc1-vip98.adobe.com wwis-dubc1-vip99.adobe.com wwis-dubc1-vip100.adobe.com wwis-dubc1-vip102.adobe.com wwis-dubc1-vip101.adobe.com wwis-dubc1-vip103.adobe.com wwis-dubc1-vip104.adobe.com wwis-dubc1-vip105.adobe.com wwis-dubc1-vip106.adobe.com wwis-dubc1-vip107.adobe.com wwis-dubc1-vip108.adobe.com wwis-dubc1-vip109.adobe.com wwis-dubc1-vip110.adobe.com wwis-dubc1-vip111.adobe.com wwis-dubc1-vip112.adobe.com wwis-dubc1-vip113.adobe.com wwis-dubc1-vip114.adobe.com wwis-dubc1-vip115.adobe.com wwis-dubc1-vip116.adobe.com wwis-dubc1-vip117.adobe.com wwis-dubc1-vip118.adobe.com wwis-dubc1-vip119.adobe.com wwis-dubc1-vip120.adobe.com wwis-dubc1-vip121.adobe.com wwis-dubc1-vip122.adobe.com wwis-dubc1-vip123.adobe.com wwis-dubc1-vip124.adobe.com wwis-dubc1-vip125.adobe.com www.adobeereg.com www.hh-software.com www.wip.adobe.com www.wip1.adobe.com www.wip2.adobe.com www.wip3.adobe.com www.wip4.adobe.com prod.adobegenuine.com assets.adobedtm.com cc-api-data.adobe.io ic.adobe.io lcs-robs.adobe.io cc-api-data.adobe.io cc-api-data-stage.adobe.io adobe.tt.omtrdc.net
goto add_host

:wondershare
set domains=cbs.wondershare.com platform.wondershare.com macplatform.wondershare.com www.wondershare.net support.wondershare.net
goto add_host

:autodesk
set domains=autodesk.fi autodesk.de autodesk.es autodesk.ca autodesk.dk autodesk.pl ns1.autodesk.com ns2.autodesk.com ns3.autodesk.com ns4.autodesk.com ns5.autodesk.com 126114-app1.autodesk.com 94175-app1.autodesk.com 94184-app2.autodesk.com 96579-lbal1.autodesk.com acamp.autodesk.com adeskdi3.autodesk.com adeskgate.autodesk.com adesknews2.autodesk.com adeskout.autodesk.com adsknateur.autodesk.com amernetlog.autodesk.com app5.autodesk.com aprimo-relay1.autodesk.com aprimo-relay2.autodesk.com aprimo-relay3.autodesk.com aprimo-relay4.autodesk.com autosketch.autodesk.com blues.autodesk.com cbuanprd.autodesk.com cbuanprhcllb.autodesk.com cbuanqa2lb.autodesk.com ci3dwsdev-svc.autodesk.com ci3dwsprd-svc.autodesk.com ci3dwsstg-svc.autodesk.com community.autodesk.com cut.autodesk.com cvsprd01.autodesk.com discussion.autodesk.com eur.autodesk.com extcidev.autodesk.com extciqa.autodesk.com extupg.autodesk.com ftp-users.autodesk.com ftp2b.autodesk.com gisdmzpdc.autodesk.com hqaribasrf04.autodesk.com hqmgwww01.autodesk.com hqmgwww04.autodesk.com hqmobileweb01.autodesk.com hqprxsrftrn.autodesk.com hqpsweb01.autodesk.com hubdev-svc.autodesk.com hubprd-svc.autodesk.com hubstg-svc.autodesk.com itappprd01-svc.autodesk.com itappprd02-svc.autodesk.com its.autodesk.com jdevextv-new.autodesk.com jp.autodesk.com jstgextv-new.autodesk.com jstgintv-new.autodesk.com lbsvzw.autodesk.com lbsvzw1.autodesk.com lbsvzw2.autodesk.com library.autodesk.com liveupdate.autodesk.com locationservices.autodesk.com lsctsol04.autodesk.com mail-relay.autodesk.com mneprdext-svc.autodesk.com mut.autodesk.com nbugma-dmz.autodesk.com nut.autodesk.com otw-new.autodesk.com otwdownloads.autodesk.com partnercenter.autodesk.com partnerproducts.autodesk.com paste.autodesk.com pedidrq.autodesk.com pediqrx.autodesk.com petars1.autodesk.com petcp11ia-2nat.autodesk.com petcr12ihsrp2.autodesk.com phxgciv.autodesk.com phxgciv_dr.autodesk.com planix3d.autodesk.com pointa.autodesk.com register.autodesk.com registerallied-pr.autodesk.com registeronce.autodesk.com salestraining.autodesk.com searchnews.autodesk.com shop.autodesk.com spamster-bulk.autodesk.com sswwwp.autodesk.com trialdownload.autodesk.com usa.autodesk.com uspetcr12ie_198.autodesk.com uspetcr12if.autodesk.com uspetcr12if_198.autodesk.com uspetcrs12ia_ib_vlan500_2_hsrp.autodesk.com uspetcrs12ia_vlan500_2.autodesk.com uspetcrs12ib_vlan500_2.autodesk.com uspetne06ia_ib_untrust_dip7.autodesk.com usrelay.autodesk.com ussclout1.autodesk.com vzwlpsrel.autodesk.com vzwlpstst.autodesk.com web.autodesk.com webservices.autodesk.com wormhole.autodesk.com www3.autodesk.com www.autodesk.com genuine-software.autodesk.com genuine-software1.autodesk.com genuine-software2.autodesk.com genuine-software3.autodesk.com
goto add_host

:lumion
set domains=backup.lumion3d.net license.lumiontech.net lumion3d.net lumiontech.net
goto add_host

:corel
set domains=apps.corel.com mc.corel.com iws.corel.com deploy.akamaitechnologies.com compute-1.amazonaws.com origin-mc.corel.com coreldraw.com www.coreldraw.com corel.com www.corel.com activation.corel.com ipm.corel.com product.corel.com idp.corel.com account.corel.com
goto add_host

:acronis
set domains=liveupdate.acronis.com activation.acronis.com web-api-tih.acronis.com download.acronis.com orders.acronis.com ns1.acronis.com ns2.acronis.com ns3.acronis.com account.acronis.com gateway.acronis.com cloud-rs-ru2.acronis.com cloud-fes-ru2.acronis.com rpc.acronis.com
goto add_host

:edithost
start notepad.exe c:\Windows\system32\drivers\etc\hosts
goto menu

:add_host
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN KE FILE HOSTS..
echo.
color 07
for %%d in (!domains!) do (
    echo 127.0.0.1    %%d >> %windir%\System32\drivers\etc\hosts
    echo  + Add 127.0.0.1 %%d
)
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'
pause >nul
goto menu

:keluar
echo.
powershell "write-host -fore 'Red' ' TEKAN ENTER UNTUK KELUAR DARI PROGRAM.'
pause >nul
exit
