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
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN ADOBE KE FILE HOSTS..
echo.
color 07
set "hostsFile=%windir%\System32\drivers\etc\hosts"
echo #BEGIN ADOBE HOSTS >> "!hostsFile!"
for %%d in (
    adobe.io
    ssrtnxk6uq6x.sf7e3.adobestats.io
    v62vpzg2av.adobestats.io
    a1815.dscr.akamai.net
    ims-na1.adobelogin.com.cdn.cloudflare.net
    o1383653.ingest.sentry.io
    wtl71c0ylo.adobestats.io
    3d5vic7so2.adobestats.io
    o987771.ingest.us.sentry.io
    vgetwxoqno.adobe.io
    cc-api-data.adobe.io
    cctypekit.adobe.io
    lm-prd-da1.licenses.adobe.com
    activate.adobe.com
    practivate-da1.adobe.com
    licenses.adobe.com
    license.adobe.com
    helpexamples.com
    gocart-web-prod-ue1-alb-1461435473.us-east-1.elb.amazonaws.com
    0mo5a70cqa.adobe.io
    pojvrj7ho5.adobe.io
    i7pq6fgbsl.adobe.io
    ph0f2h2csf.adobe.io
    r3zj0yju1q.adobe.io
    guzg78logz.adobe.io
    2ftem87osk.adobe.io
    3d3wqt96ht.adobe.io
    23ynjitwt5.adobe.io
    3ca52znvmj.adobe.io
    r5hacgq5w6.adobe.io
    lre1kgz2u4.adobe.io
    ij0gdyrfka.adobe.io
    8ncdzpmmrg.adobe.io
    7sj9n87sls.adobe.io
    7m31guub0q.adobe.io
    7g2gzgk9g1.adobe.io
    cd536oo20y.adobe.io
    dxyeyf6ecy.adobe.io
    jc95y2v12r.adobe.io
    m59b4msyph.adobe.io
    vajcbj9qgq.adobe.io
    p7uxzbht8h.adobe.io
    vcorzsld2a.adobe.io
    p0bjuoe16a.adobe.io
    fqaq3pq1o9.adobe.io
    aoorovjtha.adobe.io
    pv256ds6c99.prod.cloud.adobe.io
    cv2l4573ukh.prod.cloud.adobe.io
    pv24v41zibm.prod.cloud.adobe.io
    iv2nn9r0j2r.prod.cloud.adobe.io
    iv2yt8sqmh0.prod.cloud.adobe.io
    iv218qmzox6.prod.cloud.adobe.io
    cv218qmzox6.prod.cloud.adobe.io
    cv2b0yc07ls.prod.cloud.adobe.io
    cv2nn9r0j2r.prod.cloud.adobe.io
    pv2yt8sqmh0.prod.cloud.adobe.io
    iv256ds6c99.prod.cloud.adobe.io
    pv2zp87w2eo.prod.cloud.adobe.io
    iv2ys4tjt9x.prod.cloud.adobe.io
    cv2ska86hnt.prod.cloud.adobe.io
    iv24b15c1z0.prod.cloud.adobe.io
    cv256ds6c99.prod.cloud.adobe.io
    pv2ska86hnt.prod.cloud.adobe.io
    iv2b0yc07ls.prod.cloud.adobe.io
    iv2l4573ukh.prod.cloud.adobe.io
    cv24v41zibm.prod.cloud.adobe.io
    iv2ska86hnt.prod.cloud.adobe.io
    pv2l4573ukh.prod.cloud.adobe.io
    iv24v41zibm.prod.cloud.adobe.io
    iv2zp87w2eo.prod.cloud.adobe.io
    pv2ys4tjt9x.prod.cloud.adobe.io
    cv2ys4tjt9x.prod.cloud.adobe.io
    cv2fcqvzl1r.prod.cloud.adobe.io
    pv2fcqvzl1r.prod.cloud.adobe.io
    cv24b15c1z0.prod.cloud.adobe.io
    pv24b15c1z0.prod.cloud.adobe.io
    cv2bqhsp36w.prod.cloud.adobe.io
    pv2b0yc07ls.prod.cloud.adobe.io
    pv218qmzox6.prod.cloud.adobe.io
    cv2yt8sqmh0.prod.cloud.adobe.io
    iv2fcqvzl1r.prod.cloud.adobe.io
    pv2bqhsp36w.prod.cloud.adobe.io
    pv2nn9r0j2r.prod.cloud.adobe.io
    cv2zp87w2eo.prod.cloud.adobe.io
    iv2bqhsp36w.prod.cloud.adobe.io
    yj8yx3y8zo.adobestats.io
    mpsige2va9.adobestats.io
    ujqx8lhpz4.adobestats.io
    y2r8jzsv4p.adobestats.io
    eq7dbze88m.adobestats.io
    q9hjwppxeq.adobestats.io
    skg7pqn0al.adobestats.io
    9iay914wzy.adobestats.io
    yuzuoqo0il.adobestats.io
    2o3c6rbyfr.adobestats.io
    vicsj37lhf.adobestats.io
    nhc73ypmli.adobestats.io
    oxiz2n3i4v.adobestats.io
    2qjz50z5lf.adobestats.io
    i2x2ius9o5.adobestats.io
    lnwbupw1s7.adobestats.io
    n746qg9j4i.adobestats.io
    2621x1nzeq.adobestats.io
    r9r6oomgms.adobestats.io
    99pfl4vazm.adobestats.io
    zekdqanici.adobestats.io
    g9cli80sqp.adobestats.io
    dyv9axahup.adobestats.io
    17ov1u3gio.adobestats.io
    7l4xxjhvkt.adobestats.io
    wcxqmuxd4z.adobestats.io
    l558s6jwzy.adobestats.io
    85n85uoa1h.adobestats.io
    zrao5tdh1t.adobestats.io
    eftcpaiu36.adobestats.io
    2qj10f8rdg.adobestats.io
    ffs3xik41x.adobestats.io
    g3y09mbaam.adobestats.io
    x880ulw3h0.adobestats.io
    jaircqa037.adobestats.io
    ppn4fq68w7.adobestats.io
    1ei1f4k9yk.adobestats.io
    6j0onv1tde.adobestats.io
    pljm140ld1.adobestats.io
    50sxgwgngu.adobestats.io
    u31z50xvp9.adobestats.io
    2dhh9vsp39.adobestats.io
    rb0u8l34kr.adobestats.io
    3odrrlydxt.adobestats.io
    3u6k9as4bj.adobestats.io
    curbpindd3.adobestats.io
    4dviy9tb3o.adobestats.io
    yb6j6g0r1n.adobestats.io
    0bj2epfqn1.adobestats.io
    ura7zj55r9.adobestats.io
    xesnl0ss94.adobestats.io
    xbd20b9wqa.adobestats.io
    cr2fouxnpm.adobestats.io
    zmg3v61bbr.adobestats.io
    bk7y1gneyk.adobestats.io
    dx0nvmv4hz.adobestats.io
    eyiu19jd5w.adobestats.io
    561r5c3bz1.adobestats.io
    54cu4v5twu.adobestats.io
    6eidhihhci.adobestats.io
    31q40256l4.adobestats.io
    bs2yhuojzm.adobestats.io
    p50zgina3e.adobestats.io
    yri0bsu0ak.adobestats.io
    zu8yy3jkaz.adobestats.io
    m59cps6x3n.adobestats.io
    kgj0gsg3cf.adobestats.io
    uf0onoepoe.adobestats.io
    28t4psttw7.adobestats.io
    hjs70w1pdi.adobestats.io
    klw4np5a1x.adobestats.io
    lz2x4rks1u.adobestats.io
    pc6sk9bygv.adobestats.io
    t9phy8ywkd.adobestats.io
    dfnm3epsb7.adobestats.io
    5ky0dijg73.adobestats.io
    124hzdrtoi.adobestats.io
    69rxfbohle.adobestats.io
    9uffo0j6wj.adobestats.io
    kwi5n2ruax.adobestats.io
    nh8wam2qd9.adobestats.io
    rm3xrk61n1.adobestats.io
    rmnia8d0tr.adobestats.io
    vrz9w7o7yv.adobestats.io
    5m62o8ud26.adobestats.io
    esx6aswt5e.adobestats.io
    hwfqhlenbg.adobestats.io
    je5ufnklzs.adobestats.io
    jmx50quqz0.adobestats.io
    jsxfc5yij1.adobestats.io
    vfsjlgw02v.adobestats.io
    yshuhythub.adobestats.io
    zrbzvc9mel.adobestats.io
    rj669kv2lc.adobestats.io
    agxqobl83f.adobestats.io
    zr60t8ia88.adobestats.io
    a1y2b7wsna.adobestats.io
    22gda3bxkb.adobe.io
    fgh5v09kcn.adobe.io
    ivbnpthtl2.adobe.io
    0n8wirm0nv.adobestats.io
    17vpu0xkm6.adobestats.io
    1ngcws40i2.adobestats.io
    1qwiekvkux.adobestats.io
    1tw2l9x7xb.adobestats.io
    1unk1rv07w.adobestats.io
    1xuyy0mk2p.adobestats.io
    220zxtbjjl.adobestats.io
    2eiuxr4ky7.adobestats.io
    34modi5s5d.adobestats.io
    34u96h6rvn.adobestats.io
    3aqshzqv3w.adobestats.io
    3jq65qgxeh.adobestats.io
    3uyby7kphu.adobestats.io
    3xuuprv9lg.adobestats.io
    41yq116gxd.adobestats.io
    44qnmxgtif.adobestats.io
    4fmzz4au8r.adobestats.io
    4l6gggpz15.adobestats.io
    4yw5exucf6.adobestats.io
    5pawwgngcc.adobestats.io
    5zcrcdpvlp.adobestats.io
    6dnh2pnz6e.adobestats.io
    6mmsqon7y7.adobestats.io
    6purj8tuwe.adobestats.io
    6qkk0k4e9n.adobestats.io
    6t38sdao5e.adobestats.io
    6y6ozj4sot.adobestats.io
    6zknqfiyev.adobestats.io
    79j7psfqg5.adobestats.io
    7k1t5im229.adobestats.io
    7tu619a87v.adobestats.io
    83x20gw5jk.adobestats.io
    8tegcsplp5.adobestats.io
    98c6c096dd.adobestats.io
    98yu7gk4m3.adobestats.io
    9g12qgnfe4.adobestats.io
    9orhsmzhzs.adobestats.io
    9wm8di7ifk.adobestats.io
    a3cgga0v52.adobestats.io
    a9ctb1jmbv.adobestats.io
    ag0ak456at.adobestats.io
    ah5otkl8ie.adobestats.io
    altz51db7t.adobestats.io
    anl33sxvkb.adobestats.io
    bbraowhh29.adobestats.io
    bjooauydoa.adobestats.io
    bk8pzmo8g4.adobestats.io
    bpvcty7ry7.adobestats.io
    c474kdh1ky.adobestats.io
    c4dpyxapo7.adobestats.io
    cde0alxs25.adobestats.io
    d101mw99xq.adobestats.io
    d2ke1291mx.adobestats.io
    d6zco8is6l.adobestats.io
    dru0w44scl.adobestats.io
    dsj4bsmk6i.adobestats.io
    dymfhyu5t7.adobestats.io
    ebvf40engd.adobestats.io
    eqo0sr8daw.adobestats.io
    eu927m40hm.adobestats.io
    ffirm4ruur.adobestats.io
    fm8m3wxufy.adobestats.io
    fw6x2fs3fr.adobestats.io
    g0rhyhkd7l.adobestats.io
    gwbpood8w4.adobestats.io
    hf6s5jdv95.adobestats.io
    hijfpxclgz.adobestats.io
    hmonvr006v.adobestats.io
    hnk7phkxtg.adobestats.io
    hq0mnwz735.adobestats.io
    i4x0voa7ns.adobestats.io
    i6gl29bvy6.adobestats.io
    ijl01wuoed.adobestats.io
    iw4sp0v9h3.adobestats.io
    izke0wrq9n.adobestats.io
    j0qztjp9ep.adobestats.io
    j134yk6hv5.adobestats.io
    j14y4uzge7.adobestats.io
    j5vsm79i8a.adobestats.io
    jatil41mhk.adobestats.io
    jfb7fqf90c.adobestats.io
    jir97hss11.adobestats.io
    jsspeczo2f.adobestats.io
    jwonv590qs.adobestats.io
    jye4987hyr.adobestats.io
    k9cyzt2wha.adobestats.io
    kbdgy1yszf.adobestats.io
    kjhzwuhcel.adobestats.io
    kvi8uopy6f.adobestats.io
    kvn19sesfx.adobestats.io
    ll8xjr580v.adobestats.io
    llnh72p5m3.adobestats.io
    ltjlscpozx.adobestats.io
    lv5yrjxh6i.adobestats.io
    m95pt874uw.adobestats.io
    mge8tcrsbr.adobestats.io
    mid2473ggd.adobestats.io
    mme5z7vvqy.adobestats.io
    n0yaid7q47.adobestats.io
    n17cast4au.adobestats.io
    n78vmdxqwc.adobestats.io
    nhs5jfxg10.adobestats.io
    no95ceu36c.adobestats.io
    o1qtkpin3e.adobestats.io
    oee5i55vyo.adobestats.io
    oh41yzugiz.adobestats.io
    ok9sn4bf8f.adobestats.io
    om2h3oklke.adobestats.io
    p3lj3o9h1s.adobestats.io
    p3m760solq.adobestats.io
    pdb7v5ul5q.adobestats.io
    pf80yxt5md.adobestats.io
    psc20x5pmv.adobestats.io
    px8vklwioh.adobestats.io
    qmyqpp3xs3.adobestats.io
    qn2ex1zblg.adobestats.io
    qp5bivnlrp.adobestats.io
    qqyyhr3eqr.adobestats.io
    qttaz1hur3.adobestats.io
    qxc5z5sqkv.adobestats.io
    r1lqxul5sr.adobestats.io
    riiohpqnpf.adobestats.io
    rlo1n6mv52.adobestats.io
    s7odt342lo.adobestats.io
    sa4visje3j.adobestats.io
    sbzo5r4687.adobestats.io
    sfmzkcuf2f.adobestats.io
    tcxqcguhww.adobestats.io
    tf3an24xls.adobestats.io
    tprqy2lgua.adobestats.io
    trc2fpy0j4.adobestats.io
    tyradj47rp.adobestats.io
    ua0pnr1x8v.adobestats.io
    uo6uihbs9y.adobestats.io
    uqshzexj7y.adobestats.io
    uroc9kxpcb.adobestats.io
    uytor2bsee.adobestats.io
    v5nweiv7nf.adobestats.io
    vp7ih9xoxg.adobestats.io
    vqiktmz3k1.adobestats.io
    vqrc5mq1tm.adobestats.io
    vr1i32txj7.adobestats.io
    vr25z2lfqx.adobestats.io
    vvzbv1ba9r.adobestats.io
    w8x0780324.adobestats.io
    wjoxlf5x2z.adobestats.io
    wtooadkup9.adobestats.io
    wz8kjkd9gc.adobestats.io
    x5cupsunjc.adobestats.io
    x8kb03c0jr.adobestats.io
    x8thl73e7u.adobestats.io
    xm8abqacqz.adobestats.io
    xqh2khegrf.adobestats.io
    y53h2xkr61.adobestats.io
    y8f3hhzhsk.adobestats.io
    yaxne83fvv.adobestats.io
    z2cez9qgcl.adobestats.io
    z2yohmd1jm.adobestats.io
    z3shmocdp4.adobestats.io
    zfzx6hae4g.adobestats.io
    zooyvml70k.adobestats.io
    zqr7f445uc.adobestats.io
    zz8r2o83on.adobestats.io
    6ll72mpyxv.adobestats.io
    g6elufzgx7.adobestats.io
    gdtbhgs27n.adobestats.io
    hciylk3wpv.adobestats.io
    m8c5gtovwb.adobestats.io
    411r4c18df.adobestats.io
    475ao55klh.adobestats.io
    c0cczlv877.adobestats.io
    fsx0pbg4rz.adobestats.io
    powfb7xi5v.adobestats.io
    h3hqd6gjkd.adobestats.io
    bvcj3prq1u.adobestats.io
    0k6cw37ajl.adobestats.io
    15phzfr05l.adobestats.io
    2os6jhr955.adobestats.io
    3rm6l6bqwd.adobestats.io
    42fkk06z8c.adobestats.io
    45gnbb50sn.adobestats.io
    6482jlr7qo.adobestats.io
    7lj6w2xxew.adobestats.io
    8eptecerpq.adobestats.io
    9k4qeathc0.adobestats.io
    9yod0aafmi.adobestats.io
    dr1wq4uepg.adobestats.io
    i48z07b7gr.adobestats.io
    me7z7bchov.adobestats.io
    mvnfbgfx93.adobestats.io
    nj9rqrql3b.adobestats.io
    ns6ckzkjzg.adobestats.io
    ouovuyeiee.adobestats.io
    tld9di3jxu.adobestats.io
    xa8g202i4u.adobestats.io
    z83qksw5cq.adobestats.io
    9mblf9n5zf.adobestats.io
    be5d7iw6y1.adobestats.io
    cxqenfk6in.adobestats.io
    cim9wvs3is.adobestats.io
    ar1hqm61sk.adobestats.io
    iqhvrdhql4.adobestats.io
    cducupwlaq.adobestats.io
    sap3m7umfu.adobestats.io
    ay8wypezvi.adobestats.io
    1j3muid89l.adobestats.io
    8167gz60t1.adobestats.io
    2bns2f5eza.adobestats.io
    2c3bqjchr6.adobestats.io
    49vfady5kf.adobestats.io
    7v0i13wiuf.adobestats.io
    ak1ow4e0u3.adobestats.io
    f8m1p3tltt.adobestats.io
    l6uu15bwug.adobestats.io
    rtfuwp21b3.adobestats.io
    s8liwh6vbn.adobestats.io
    ok02isdwcx.adobestats.io
    c72tusw5wi.adobestats.io
    dqaytc21nb.adobestats.io
    gm2ai4nsfq.adobestats.io
    hs6dwhuiwh.adobestats.io
    kst1t43sji.adobestats.io
    x12wor9jo6.adobestats.io
    xgj8lmrcy6.adobestats.io
    6unmig6t9w.adobestats.io
    36ai1uk1z7.adobestats.io
    8nft9ke95j.adobestats.io
    9sg9gr4zf4.adobestats.io
    tagtjqcvqg.adobestats.io
    ztxgqqizv7.adobestats.io
    7mw85h5tv4.adobestats.io
    5amul9liob.adobestats.io
    cfh5v77fsy.adobestats.io
    dobw5hakm0.adobestats.io
    08n59yhbxn.adobestats.io
    0p73385wa6.adobestats.io
    0vrs1f5fso.adobestats.io
    5et944c3kg.adobestats.io
    610o7ktxw7.adobestats.io
    b8qwvscik0.adobestats.io
    cvl65mxwmh.adobestats.io
    dtt06hnkyj.adobestats.io
    fg7bb8gi6d.adobestats.io
    iy304996hm.adobestats.io
    lp4og15wl5.adobestats.io
    nxq02alk63.adobestats.io
    ofgajs60g1.adobestats.io
    om52ny8l9s.adobestats.io
    s14z1kt85g.adobestats.io
    tyqs8bsps8.adobestats.io
    vvpexgmc5t.adobestats.io
    w3ffpxhbn6.adobestats.io
    w58drkayqf.adobestats.io
    w8mvrujj91.adobestats.io
    wjpmg2uott.adobestats.io
    xljz63k33x.adobestats.io
    7micpuqiwp.adobestats.io
    2lb39igrph.adobestats.io
    3zgi4mscuk.adobestats.io
    elf5yl77ju.adobestats.io
    ktb8rx6uhe.adobestats.io
    heufuideue.adobestats.io
    xq68npgl4w.adobestats.io
    vnm70hlbn4.adobestats.io
    p4hiwy76wl.adobestats.io
    q7i4awui0j.adobestats.io
    soirhk7bm2.adobestats.io
    0789i4f3cq.adobestats.io
    827x3zvk4q.adobestats.io
    8ljcntz31v.adobestats.io
    95yojg6epq.adobestats.io
    9wcrtdzcti.adobestats.io
    a3dxeq2iq9.adobestats.io
    hrfn4gru1j.adobestats.io
    kx8yghodgl.adobestats.io
    olh5t1ccns.adobestats.io
    svcgy434g6.adobestats.io
    uwr2upexhs.adobestats.io
    wk0sculz2x.adobestats.io
    xbhspynj8t.adobestats.io
    xod1t4qsyk.adobestats.io
    iu7mq0jcce.adobestats.io
    tdatxzi3t4.adobestats.io
    rptowanjjh.adobestats.io
    3cnu7l5q8s.adobestats.io
    ow1o9yr32j.adobestats.io
    bc27a8e3zw.adobestats.io
    ok6tbgxfta.adobestats.io
    9nqvoa544j.adobestats.io
    arzggvbs37.adobestats.io
    d8hof9a6gg.adobestats.io
    qh0htdwe2n.adobestats.io
    fu9wr8tk0u.adobestats.io
    0ss1vovh4a.adobestats.io
    15ousmguga.adobestats.io
    3oidzvonpa.adobestats.io
    5pjcqccrcu.adobestats.io
    75ffpy5iio.adobestats.io
    7fj42ny0sd.adobestats.io
    drwizwikc0.adobestats.io
    fl34tml8is.adobestats.io
    kd4c3z4xbz.adobestats.io
    ksw6oyvdk6.adobestats.io
    l91nnnkmbi.adobestats.io
    ln3pv36xx8.adobestats.io
    m5cgk2pkdn.adobestats.io
    nj66fd4dzr.adobestats.io
    nl00xmmmn5.adobestats.io
    wn9kta1iw4.adobestats.io
    x3sszs7ihy.adobestats.io
    nrenlhdc1t.adobestats.io
    6nbt0kofc7.adobestats.io
    kmqhqhs02w.adobestats.io
    wdyav7y3rf.adobestats.io
    3ysvacl1hb.adobestats.io
    bqbvmlmtmo.adobestats.io
    zn0o46rt48.adobestats.io
    8mtavkaq40.adobestats.io
    52h0nva0wa.adobestats.io
    4t5jyh9fkk.adobestats.io
    hen2jsru7c.adobestats.io
    6tpqsy07cp.adobestats.io
    0andkf1e8e.adobestats.io
    2kc4lqhpto.adobestats.io
    43q1uykg1z.adobestats.io
    7zak80l8ic.adobestats.io
    9dal0pbsx3.adobestats.io
    9rcgbke6qx.adobestats.io
    cwejcdduvp.adobestats.io
    dq1gubixz7.adobestats.io
    fc2k38te2m.adobestats.io
    i1j2plx3mv.adobestats.io
    lnosso28q5.adobestats.io
    npt74s16x9.adobestats.io
    o6pk3ypjcf.adobestats.io
    pcmdl6zcfd.adobestats.io
    q0z6ycmvhl.adobestats.io
    quptxdg94y.adobestats.io
    s4y2s7r9ah.adobestats.io
    yajkeabyrj.adobestats.io
    r9qg11e83v.adobestats.io
    13hceguz11.adobestats.io
    4xosvsrdto.adobestats.io
    72p3yx09zx.adobestats.io
    7gu7j31tn3.adobestats.io
    hob0cz1xnx.adobestats.io
    fp.adobestats.io
    6woibl6fiu.adobestats.io
    jh34ro8dm2.adobestats.io
    sz2edaz2s9.adobestats.io
    4s6bg7xces.adobestats.io
    3d5rp7oyng.adobestats.io
    5dec9025sr.adobestats.io
    5muggmgxyb.adobestats.io
    94enlu8vov.adobestats.io
    9pa13v8uko.adobestats.io
    csb8usj9o4.adobestats.io
    dxegvh5wpp.adobestats.io
    itiabkzm7h.adobestats.io
    jsusbknzle.adobestats.io
    tzbl46vv9o.adobestats.io
    v5zm23ixg2.adobestats.io
    w9m8uwm145.adobestats.io
    zf37mp80xx.adobestats.io
    gyt27lbjb3.adobestats.io
    3m3e8ccqyo.adobestats.io
    2sug8qxjag.adobestats.io
    36ivntopuj.adobestats.io
    1eqkbrjz78.adobestats.io
    szvbv5h62r.adobestats.io
    zf1aegmmle.adobestats.io
    50lifxkein.adobestats.io
    dfwv44wffr.adobestats.io
    qwzzhqpliv.adobestats.io
    0wcraxg290.adobestats.io
    gpd3r2mkgs.adobestats.io
    116n6tkxyr.adobestats.io
    3nkkaf8h85.adobestats.io
    55oguiniw8.adobestats.io
    e1tyeiimw3.adobestats.io
    g7zh7zqzqx.adobestats.io
    gglnjgxaia.adobestats.io
    h33a7kps0t.adobestats.io
    jewn0nrrp8.adobestats.io
    r7sawld5l6.adobestats.io
    vodh16neme.adobestats.io
    wntfgdo4ki.adobestats.io
    x9u2jsesk0.adobestats.io
    xsn76p7ntx.adobestats.io
    xz9xjlyw58.adobestats.io
    as73qhl83n.adobestats.io
    b0giyj3mc1.adobestats.io
    f9554salkg.adobestats.io
    i487nlno13.adobestats.io
    qx2t3lrpmg.adobestats.io
    r0exxqftud.adobestats.io
    spbuswk2di.adobestats.io
    swxs9c0fpt.adobestats.io
    v7esmx1n0s.adobestats.io
    zglaizubbj.adobestats.io
    22wqqv6b23.adobestats.io
    5jdb1nfklf.adobestats.io
    6glym36rbb.adobestats.io
    6h8391pvf8.adobestats.io
    c675s4pigj.adobestats.io
    c8pyxo4r20.adobestats.io
    co9sg87h3h.adobestats.io
    f8wflegco1.adobestats.io
    g6ld7orx5r.adobestats.io
    r00r33ldza.adobestats.io
    scmnpedxm0.adobestats.io
    slx5l73jwh.adobestats.io
    w8yfgti2yd.adobestats.io
    yljkdk5tky.adobestats.io
    0oydr1f856.adobestats.io
    3ea8nnv3fo.adobestats.io
    4j225l63ny.adobestats.io
    4pbmn87uov.adobestats.io
    8z20kcq3af.adobestats.io
    bp5qqybokw.adobestats.io
    dri0xipdj1.adobestats.io
    e8yny99m61.adobestats.io
    etqjl6s9m9.adobestats.io
    iyuzq3njtk.adobestats.io
    k2zeiskfro.adobestats.io
    kk6mqz4ho1.adobestats.io
    ltby3lmge7.adobestats.io
    m07jtnnega.adobestats.io
    o9617jdaiw.adobestats.io
    ry9atn2zzw.adobestats.io
    t8nxhdgbcb.adobestats.io
    yhxcdjy2st.adobestats.io
    1yzch4f7fj.adobestats.io
    2dym9ld8t4.adobestats.io
    7857z7jy1n.adobestats.io
    917wzppd6w.adobestats.io
    acakpm3wmd.adobestats.io
    ah0uf3uzwe.adobestats.io
    anllgxlrgl.adobestats.io
    ar3zpq1idw.adobestats.io
    as15ffplma.adobestats.io
    b343x3kjgp.adobestats.io
    b4ur7jk78w.adobestats.io
    c7udtzsk2j.adobestats.io
    dt549nqpx7.adobestats.io
    f7ul6vs4ha.adobestats.io
    hbejpf1qou.adobestats.io
    s6195z8x2q.adobestats.io
    smtcbgh2n7.adobestats.io
    v5f89yjtcw.adobestats.io
    x66v4qn2t7.adobestats.io
    yvbzqwn2gz.adobestats.io
    1ompyaokc3.adobestats.io
    2ent6j0ret.adobestats.io
    7860w7avqe.adobestats.io
    kqs7x93q8r.adobestats.io
    now8wpo1bv.adobestats.io
    oeab9s6dtf.adobestats.io
    p4apxcgh7b.adobestats.io
    rs2deio0ks.adobestats.io
    wfyeckyxxx.adobestats.io
    xngv0345gb.adobestats.io
    5nae7ued1i.adobestats.io
    74jqw6xdam.adobestats.io
    9xxyu4ncc9.adobestats.io
    ckh0swnp4c.adobestats.io
    dr02lso5fh.adobestats.io
    et3x020m0i.adobestats.io
    g58jqxdh3y.adobestats.io
    j7wq25n7dy.adobestats.io
    a69wv3f4j3.adobestats.io
    jwi6q78hu2.adobestats.io
    nw3ft2wlrn.adobestats.io
    yykww43js1.adobestats.io
    12ihfrf869.adobestats.io
    a5dtr1c4er.adobestats.io
    ajs31fsy2t.adobestats.io
    mi9rav314a.adobestats.io
    z66m01zo11.adobestats.io
    vd8bjo50bv.adobestats.io
    tqcbs617dw.adobe.io
    fcbx058i0c.adobe.io
    chlydkc9bz.adobe.io
    4f1b1vqcfi.adobestats.io
    ci5yrifbog.adobestats.io
    vn4waib0dk.adobestats.io
    drdqxhlcop.adobe.io
    1i09xck9hj.adobestats.io
    kp.adobestats.io
    quij2u03a1.adobestats.io
    xo9j8bcw4a.adobe.io
    3.233.129.217
    192.150.14.69
    192.150.18.101
    192.150.18.108
    192.150.22.40
    192.150.8.100
    192.150.8.118
    199.7.52.190
    199.7.54.72
    209-34-83-73.ood.opsource.net
    209.34.83.67
    209.34.83.73
    18.207.85.246
    52.6.155.20
    52.10.49.85
    23.22.30.141
    34.215.42.13
    52.84.156.37
    65.8.207.109
    3.220.11.113
    3.221.72.231
    3.216.32.253
    3.208.248.199
    3.219.243.226
    13.227.103.57
    34.192.151.90
    34.237.241.83
    44.240.189.42
    52.20.222.155
    52.208.86.132
    54.208.86.132
    63.140.38.120
    63.140.38.160
    63.140.38.169
    63.140.38.219
    18.228.243.121
    18.230.164.221
    54.156.135.114
    54.221.228.134
    54.224.241.105
    100.24.211.130
    162.247.242.20
    ic.adobe.io
    b5kbg2ggog.adobe.io
    3dns-1.adobe.com
    3dns-2.adobe.com
    3dns-3.adobe.com
    3dns-4.adobe.com
    3dns-5.adobe.com
    3dns.adobe.com
    activate-sea.adobe.com
    activate-sea.adobe.de
    activate-sjc0.adobe.com
    activate-sjc0.adobe.de
    activate.adobe.de
    activate.wip.adobe.com
    activate.wip1.adobe.com
    activate.wip2.adobe.com
    activate.wip3.adobe.com
    activate.wip3.adobe.de
    activate.wip4.adobe.com
    adobe-dns-1.adobe.com
    adobe-dns-2.adobe.com
    adobe-dns-2.adobe.de
    adobe-dns-3.adobe.com
    adobe-dns-3.adobe.de
    adobe-dns-4.adobe.com
    adobe-dns.adobe.com
    adobe-dns.adobe.de
    adobe.activate.com
    adobeereg.com
    cmdls.adobe.com
    crl.verisign.net
    ereg.adobe.com
    ereg.adobe.de
    ereg.wip.adobe.com
    ereg.wip1.adobe.com
    ereg.wip2.adobe.com
    ereg.wip3.adobe.com
    ereg.wip4.adobe.com
    genuine.adobe.com
    hlrcv.stage.adobe.com
    hl2rcv.adobe.com
    hl2rcv.adobe.de
    ims-na1-prprod.adobelogin.com
    lm.licenses.adobe.com
    lmlicenses.wip4.adobe.com
    na1r.services.adobe.com
    na2m-pr.licenses.adobe.com
    na2m-stg2.licenses.adobe.com
    na4r.services.adobe.com
    ocsp.spo1.verisign.com
    ood.opsource.net
    practivate.adobe
    practivate.adobe.
    practivate.adobe.com
    practivate.adobe.de
    practivate.adobe.ipp
    practivate.adobe.newoa
    practivate.adobe.ntp
    prod-rel-ffc-ccm.oobesaas.adobe.com
    s-2.adobe.com
    s-3.adobe.com
    tss-geotrust-crl.thawte.com
    uds.licenses.adobe.com
    1hzopx6nz7.adobe.io
    p13n.adobe.io
    wip1.adobe.com
    wip2.adobe.com
    wip3.adobe.com
    wip4.adobe.com
    wwis-dubc1-vip100.adobe.com
    wwis-dubc1-vip101.adobe.com
    wwis-dubc1-vip102.adobe.com
    wwis-dubc1-vip103.adobe.com
    wwis-dubc1-vip104.adobe.com
    wwis-dubc1-vip105.adobe.com
    wwis-dubc1-vip106.adobe.com
    wwis-dubc1-vip107.adobe.com
    wwis-dubc1-vip108.adobe.com
    wwis-dubc1-vip109.adobe.com
    wwis-dubc1-vip110.adobe.com
    wwis-dubc1-vip111.adobe.com
    wwis-dubc1-vip112.adobe.com
    wwis-dubc1-vip113.adobe.com
    wwis-dubc1-vip114.adobe.com
    wwis-dubc1-vip115.adobe.com
    wwis-dubc1-vip116.adobe.com
    wwis-dubc1-vip117.adobe.com
    wwis-dubc1-vip118.adobe.com
    wwis-dubc1-vip119.adobe.com
    wwis-dubc1-vip120.adobe.com
    wwis-dubc1-vip121.adobe.com
    wwis-dubc1-vip122.adobe.com
    wwis-dubc1-vip123.adobe.com
    wwis-dubc1-vip124.adobe.com
    wwis-dubc1-vip125.adobe.com
    wwis-dubc1-vip30.adobe.com
    wwis-dubc1-vip31.adobe.com
    wwis-dubc1-vip32.adobe.com
    wwis-dubc1-vip33.adobe.com
    wwis-dubc1-vip34.adobe.com
    wwis-dubc1-vip35.adobe.com
    wwis-dubc1-vip36.adobe.com
    wwis-dubc1-vip37.adobe.com
    wwis-dubc1-vip38.adobe.com
    wwis-dubc1-vip39.adobe.com
    wwis-dubc1-vip40.adobe.com
    wwis-dubc1-vip41.adobe.com
    wwis-dubc1-vip42.adobe.com
    wwis-dubc1-vip43.adobe.com
    wwis-dubc1-vip44.adobe.com
    wwis-dubc1-vip45.adobe.com
    wwis-dubc1-vip46.adobe.com
    wwis-dubc1-vip47.adobe.com
    wwis-dubc1-vip48.adobe.com
    wwis-dubc1-vip49.adobe.com
    wwis-dubc1-vip50.adobe.com
    wwis-dubc1-vip51.adobe.com
    wwis-dubc1-vip52.adobe.com
    wwis-dubc1-vip53.adobe.com
    wwis-dubc1-vip54.adobe.com
    wwis-dubc1-vip55.adobe.com
    wwis-dubc1-vip56.adobe.com
    wwis-dubc1-vip57.adobe.com
    wwis-dubc1-vip58.adobe.com
    wwis-dubc1-vip59.adobe.com
    wwis-dubc1-vip60.adobe.com
    wwis-dubc1-vip60.adobe.de
    wwis-dubc1-vip61.adobe.com
    wwis-dubc1-vip62.adobe.com
    wwis-dubc1-vip63.adobe.com
    wwis-dubc1-vip64.adobe.com
    wwis-dubc1-vip65.adobe.com
    wwis-dubc1-vip66.adobe.com
    wwis-dubc1-vip67.adobe.com
    wwis-dubc1-vip68.adobe.com
    wwis-dubc1-vip69.adobe.com
    wwis-dubc1-vip70.adobe.com
    wwis-dubc1-vip71.adobe.com
    wwis-dubc1-vip72.adobe.com
    wwis-dubc1-vip73.adobe.com
    wwis-dubc1-vip74.adobe.com
    wwis-dubc1-vip75.adobe.com
    wwis-dubc1-vip76.adobe.com
    wwis-dubc1-vip77.adobe.com
    wwis-dubc1-vip78.adobe.com
    wwis-dubc1-vip79.adobe.com
    wwis-dubc1-vip80.adobe.com
    wwis-dubc1-vip81.adobe.com
    wwis-dubc1-vip82.adobe.com
    wwis-dubc1-vip83.adobe.com
    wwis-dubc1-vip84.adobe.com
    wwis-dubc1-vip85.adobe.com
    wwis-dubc1-vip86.adobe.com
    wwis-dubc1-vip87.adobe.com
    wwis-dubc1-vip88.adobe.com
    wwis-dubc1-vip89.adobe.com
    wwis-dubc1-vip90.adobe.com
    wwis-dubc1-vip91.adobe.com
    wwis-dubc1-vip92.adobe.com
    wwis-dubc1-vip93.adobe.com
    wwis-dubc1-vip94.adobe.com
    wwis-dubc1-vip95.adobe.com
    wwis-dubc1-vip96.adobe.com
    wwis-dubc1-vip97.adobe.com
    wwis-dubc1-vip98.adobe.com
    wwis-dubc1-vip99.adobe.com
    www.adobeereg.com
    prod.adobegenuine.com
    assets.adobedtm.com
    4vzokhpsbs.adobe.io
    69tu0xswvq.adobe.io
    5zgzzv92gn.adobe.io
    dyzt55url8.adobe.io
    gw8gfjbs05.adobe.io
    wip.adobe.com
    199.232.114.137
    www.wip.adobe.com
    www.wip1.adobe.com
    www.wip2.adobe.com
    www.wip3.adobe.com
    www.wip4.adobe.com
    workflow-ui-prod.licensingstack.com
    1b9khekel6.adobe.io
    adobe-dns-01.adobe.com
    adobe.demdex.net
    adobe.tt.omtrdc.net
    adobedc.demdex.net
    auth-cloudfront.prod.ims.adobejanus.com
    cai-splunk-proxy.adobe.io
    cc-cdn.adobe.com
    cc-cdn.adobe.com.edgekey.net
    cclibraries-defaults-cdn.adobe.com
    cclibraries-defaults-cdn.adobe.com.edgekey.net
    cn-assets.adobedtm.com.edgekey.net
    crlog-crcn.adobe.com
    crs.cr.adobe.com
    edgeproxy-irl1.cloud.adobe.io
    ethos.ethos02-prod-irl1.ethos.adobe.net
    geo2.adobe.com
    lcs-cops.adobe.io
    lcs-robs.adobe.io
    services.prod.ims.adobejanus.com
    ssl-delivery.adobe.com.edgekey.net
    sstats.adobe.com
    stls.adobe.com-cn.edgesuite.net
    stls.adobe.com-cn.edgesuite.net.globalredir.akadns.net
    use-stls.adobe.com.edgesuite.net
    9ngulmtgqi.adobe.io
    flutt9urxr.adobestats.io
    49xq1olxsn.adobestats.io
    cetufizozr12.mw1i8.adobestats.io
    hbc.adobe.io
    rekkvg49.mw1i8.adobestats.io
    y1sg2131f84.mw1i8.adobestats.io
    jgletrkp.mw1i8.adobestats.io
) do (
    findstr /L /C:"%%d" "!hostsFile!" >nul
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "!hostsFile!"
        echo  + Add %%d
    ) else (
        echo [Sudah ada]  %%d
    )
)
echo #END ADOBE HOSTS >> "!hostsFile!"
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'"
pause >nul
goto menu

:autodesk
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN AUTODESK KE FILE HOSTS..
echo.
color 07
set "hostsFile=%windir%\System32\drivers\etc\hosts"
echo #BEGIN AUTODESK HOSTS >> "!hostsFile!"
for %%d in (
    autodesk.fi
    autodesk.de
    autodesk.es
    autodesk.ca
    autodesk.dk
    autodesk.pl
    ns1.autodesk.com
    ns2.autodesk.com
    ns3.autodesk.com
    ns4.autodesk.com
    ns5.autodesk.com
    126114-app1.autodesk.com
    94175-app1.autodesk.com
    94184-app2.autodesk.com
    96579-lbal1.autodesk.com
    acamp.autodesk.com
    adeskdi3.autodesk.com
    adeskgate.autodesk.com
    adesknews2.autodesk.com
    adeskout.autodesk.com
    adsknateur.autodesk.com
    amernetlog.autodesk.com
    app5.autodesk.com
    aprimo-relay1.autodesk.com
    aprimo-relay2.autodesk.com
    aprimo-relay3.autodesk.com
    aprimo-relay4.autodesk.com
    autosketch.autodesk.com
    blues.autodesk.com
    cbuanprd.autodesk.com
    cbuanprhcllb.autodesk.com
    cbuanqa2lb.autodesk.com
    ci3dwsdev-svc.autodesk.com
    ci3dwsprd-svc.autodesk.com
    ci3dwsstg-svc.autodesk.com
    community.autodesk.com
    cut.autodesk.com
    cvsprd01.autodesk.com
    discussion.autodesk.com
    eur.autodesk.com
    extcidev.autodesk.com
    extciqa.autodesk.com
    extupg.autodesk.com
    ftp-users.autodesk.com
    ftp2b.autodesk.com
    gisdmzpdc.autodesk.com
    hqaribasrf04.autodesk.com
    hqmgwww01.autodesk.com
    hqmgwww04.autodesk.com
    hqmobileweb01.autodesk.com
    hqprxsrftrn.autodesk.com
    hqpsweb01.autodesk.com
    hubdev-svc.autodesk.com
    hubprd-svc.autodesk.com
    hubstg-svc.autodesk.com
    itappprd01-svc.autodesk.com
    itappprd02-svc.autodesk.com
    its.autodesk.com
    jdevextv-new.autodesk.com
    jp.autodesk.com
    jstgextv-new.autodesk.com
    jstgintv-new.autodesk.com
    lbsvzw.autodesk.com
    lbsvzw1.autodesk.com
    lbsvzw2.autodesk.com
    library.autodesk.com
    liveupdate.autodesk.com
    locationservices.autodesk.com
    lsctsol04.autodesk.com
    mail-relay.autodesk.com
    mneprdext-svc.autodesk.com
    mut.autodesk.com
    nbugma-dmz.autodesk.com
    nut.autodesk.com
    otw-new.autodesk.com
    otwdownloads.autodesk.com
    partnercenter.autodesk.com
    partnerproducts.autodesk.com
    paste.autodesk.com
    pedidrq.autodesk.com
    pediqrx.autodesk.com
    petars1.autodesk.com
    petcp11ia-2nat.autodesk.com
    petcr12ihsrp2.autodesk.com
    phxgciv.autodesk.com
    phxgciv_dr.autodesk.com
    planix3d.autodesk.com
    pointa.autodesk.com
    register.autodesk.com
    registerallied-pr.autodesk.com
    registeronce.autodesk.com
    salestraining.autodesk.com
    searchnews.autodesk.com
    shop.autodesk.com
    spamster-bulk.autodesk.com
    sswwwp.autodesk.com
    trialdownload.autodesk.com
    usa.autodesk.com
    uspetcr12ie_198.autodesk.com
    uspetcr12if.autodesk.com
    uspetcr12if_198.autodesk.com
    uspetcrs12ia_ib_vlan500_2_hsrp.autodesk.com
    uspetcrs12ia_vlan500_2.autodesk.com
    uspetcrs12ib_vlan500_2.autodesk.com
    uspetne06ia_ib_untrust_dip7.autodesk.com
    usrelay.autodesk.com
    ussclout1.autodesk.com
    vzwlpsrel.autodesk.com
    vzwlpstst.autodesk.com
    web.autodesk.com
    webservices.autodesk.com
    wormhole.autodesk.com
    www3.autodesk.com
    www.autodesk.com
    genuine-software.autodesk.com
    genuine-software1.autodesk.com
    genuine-software2.autodesk.com
    genuine-software3.autodesk.com
    ase-cdn-stg.autodesk.com
    ase.autodesk.com
    api.genuine-software.autodesk.com
) do (
    findstr /L /C:"%%d" "!hostsFile!" >nul
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "!hostsFile!"
        echo  + Add %%d
    ) else (
        echo [Sudah ada]  %%d
    )
)
echo #END AUTODESK HOSTS >> "!hostsFile!"
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'"
pause >nul
goto menu

:wondershare
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN WONDERSHARE KE FILE HOSTS..
echo.
color 07
set "hostsFile=%windir%\System32\drivers\etc\hosts"
echo #BEGIN WONDERSHARE HOSTS >> "!hostsFile!"
for %%d in (
    cbs.wondershare.com
    platform.wondershare.com
    macplatform.wondershare.com
    www.wondershare.net
    activation.cyberlink.com 
    pc-api.wondershare.cc 
    analytics.wondershare.cc 
    cloud-api.wondershare.cc  
    sparrow.wondershare.com 
    wae.wondershare.cc 
    api.wondershare.com  
    antipiracy.wondershare.com  
    wondershare.com 
    mail.insidews.wondershare.com 
    accounts.wondershare.com
) do (
    findstr /L /C:"%%d" "!hostsFile!" >nul
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "!hostsFile!"
        echo  + Add %%d
    ) else (
        echo [Sudah ada]  %%d
    )
)
echo #END WONDERSHARE HOSTS >> "!hostsFile!"
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'"
pause >nul
goto menu

:lumion
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN LUMION KE FILE HOSTS..
echo.
color 07
set "hostsFile=%windir%\System32\drivers\etc\hosts"
echo #BEGIN LUMION HOSTS >> "!hostsFile!"
for %%d in (
    backup.lumion3d.net
    license.lumiontech.net
    lumion3d.net
    lumiontech.net
) do (
    findstr /L /C:"%%d" "!hostsFile!" >nul
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "!hostsFile!"
        echo  + Add %%d
    ) else (
        echo [Sudah ada]  %%d
    )
)
echo #END LUMION HOSTS >> "!hostsFile!"
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'"
pause >nul
goto menu

:corel
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN COREL KE FILE HOSTS..
echo.
color 07
set "hostsFile=%windir%\System32\drivers\etc\hosts"
echo #BEGIN COREL HOSTS >> "!hostsFile!"
for %%d in (
    apps.corel.com
    mc.corel.com
    iws.corel.com
    deploy.akamaitechnologies.com
    compute-1.amazonaws.com
    origin-mc.corel.com
    coreldraw.com
    corel.com
    www.coreldraw.com
    www.corel.com
    www.corelstore.com
    activation.corel.com
    ipm.corel.com
    product.corel.com
    idp.corel.com
    idp.coreldraw.com
    myaccount.corel.com
    iws.corel.com
    2.18.12.147
    corelstore.com
    dev1.ipm.corel.public.corel.net
    ipp.corel.com
) do (
    findstr /L /C:"%%d" "!hostsFile!" >nul
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "!hostsFile!"
        echo  + Add %%d
    ) else (
        echo [Sudah ada]  %%d
    )
)
echo #END COREL HOSTS >> "!hostsFile!"
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'"
pause >nul
goto menu

:acronis
cls
echo ------------------------------------------------------------------------------------------
echo MENAMBAHKAN DOMAIN ACRONIS KE FILE HOSTS..
echo.
color 07
set "hostsFile=%windir%\System32\drivers\etc\hosts"
echo #BEGIN ACRONIS HOSTS >> "!hostsFile!"
for %%d in (
    liveupdate.acronis.com
    activation.acronis.com
    web-api-tih.acronis.com
    download.acronis.com
    orders.acronis.com
    ns1.acronis.com
    ns2.acronis.com
    ns3.acronis.com
    account.acronis.com
    gateway.acronis.com
    cloud-rs-ru2.acronis.com
    cloud-fes-ru2.acronis.com
    rpc.acronis.com
) do (
    findstr /L /C:"%%d" "!hostsFile!" >nul
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "!hostsFile!"
        echo  + Add %%d
    ) else (
        echo [Sudah ada]  %%d
    )
)
echo #END ACRONIS HOSTS >> "!hostsFile!"
echo ------------------------------------------------------------------------------------------
echo  FlushDNS..
ipconfig /flushdns
echo.
powershell "write-host -fore 'Green' '  DOMAIN TELAH DITAMBAHKAN KE FILE HOST DAN CACHE... TEKAN ENTER UNTUK KEMBALI.'"
pause >nul
goto menu

:edithost
start notepad.exe c:\Windows\system32\drivers\etc\hosts
goto menu

:keluar
echo.
powershell "write-host -fore 'Red' ' TEKAN ENTER UNTUK KELUAR DARI PROGRAM.'
pause >nul
exit