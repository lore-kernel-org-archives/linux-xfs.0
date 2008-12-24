Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBOAHTmZ001755
	for <linux-xfs@oss.sgi.com>; Wed, 24 Dec 2008 04:17:29 -0600
Received: from mail.euroimmun.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9E1D45543
	for <linux-xfs@oss.sgi.com>; Wed, 24 Dec 2008 02:17:24 -0800 (PST)
Received: from mail.euroimmun.de (mail.euroimmun.de [62.159.94.122]) by
	cuda.sgi.com with ESMTP id 0PLryqjfMeBFF5Ud for
	<linux-xfs@oss.sgi.com>; Wed, 24 Dec 2008 02:17:24 -0800 (PST)
Received: from mc1.euroimmun.de ([172.16.254.1])
	by mail.euroimmun.de with esmtpsa (TLSv1:AES256-SHA:256) (Exim 4.43)
	id 1LFQno-0007mC-T5
	for linux-xfs@oss.sgi.com; Wed, 24 Dec 2008 11:17:22 +0100
Message-ID: <49520C2D.5080601@euroimmun.de>
Date: Wed, 24 Dec 2008 11:17:17 +0100
From: "M.Cypris" <m.cypris@euroimmun.de>
MIME-Version: 1.0
Subject: question ?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0436498388226529805=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

This is a cryptographically signed message in MIME format.

--===============0436498388226529805==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms010902080306040800000406"

This is a cryptographically signed message in MIME format.

--------------ms010902080306040800000406
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

data fork in ino 4056744656 claims free block 521849722
data fork in ino 4056744656 claims free block 521849723
data fork in ino 4056744656 claims free block 521849724
data fork in ino 4056744656 claims free block 521849725
data fork in ino 4056744656 claims free block 521849726
data fork in ino 4056744656 claims free block 521849727
data fork in ino 4056744656 claims free block 521849729
data fork in ino 4056744667 claims free block 319386679
         - agno =3D 16
         - agno =3D 17
         - agno =3D 19
         - agno =3D 20
         - agno =3D 22
         - agno =3D 23
         - agno =3D 25
         - agno =3D 26
         - agno =3D 27
         - agno =3D 29
         - agno =3D 30
         - agno =3D 31
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - clear lost+found (if it exists) ...
         - clearing existing "lost+found" inode
         - check for inodes claiming duplicate blocks...
         - agno =3D 0
entry "JSADM.exv" at block 0 offset 2616 in directory inode 39152=20
references fre
e inode 39742
         clearing inode number in entry at offset 2616...
entry "AdobeCMapFnt07.lst" at block 0 offset 2664 in directory inode=20
39152 refer
         clearing inode number in entry at offset 2664...
         - agno =3D 1
bad data fork in inode 268491301
cleared inode 268491301
         - agno =3D 2
entry "calvar.ini" at block 0 offset 3136 in directory inode 536909609=20
reference
s free inode 536912996
         clearing inode number in entry at offset 3136...
entry "acad.mnr" at block 0 offset 3160 in directory inode 536909609=20
references
         clearing inode number in entry at offset 3160...
entry "Thumbs.db" in shortform directory 536931591 references free inode=20
5369316
junking entry "Thumbs.db" in directory inode 536931591
         - agno =3D 3
data fork in ino 1073765375 claims dup extent, off - 0, start -=20
404442312, cnt 1
bad data fork in inode 1073765375
cleared inode 1073765375
entry "org.openoffice.Office.OptionsDialog.dat" at block 0 offset 3432=20
in direct
ory inode 1073771053 references free inode 1073772857
         clearing inode number in entry at offset 3432...
entry "files.MYI" at block 0 offset 2040 in directory inode 1073771423=20
reference
s free inode 1073758984
         clearing inode number in entry at offset 2040...
entry "favorites.frm" at block 0 offset 2136 in directory inode=20
1073771423 refer
ences free inode 1073782807
         clearing inode number in entry at offset 2136...
entry "files.MYD" at block 0 offset 2160 in directory inode 1073771423=20
reference
s free inode 1073795156
         clearing inode number in entry at offset 2160...
entry "Annotation_A0CCA60A-AB56-4EFD-83A5-8764BC08CDA8.atc" at block 0=20
offset 52
0 in directory inode 1073782824 references free inode 1073800859
         clearing inode number in entry at offset 520...
         - agno =3D 5
entry "btiryakioglu@online.metroturizm.com[2].txt" at block 20 offset=20
2760 in di
rectory inode 1342192000 references free inode 1342199976
         clearing inode number in entry at offset 2760...
data fork in regular inode 1342225423 claims used block 149306464
correcting nblocks for inode 1342225423, was 3 - counted 0
         - agno =3D 6
entry "Color Settings.csf" at block 0 offset 72 in directory inode=20
1610654999 re
ferences free inode 1610668079
         clearing inode number in entry at offset 72...
entry "PluginCache.psp" at block 0 offset 2648 in directory inode=20
1610654999 ref
erences free inode 1610654496
         - agno =3D 7
         - agno =3D 8
         - agno =3D 9
         - agno =3D 10
entry "KAgent.cfg" at block 0 offset 1896 in directory inode 2699352171=20
referenc
         clearing inode number in entry at offset 1896...
entry "KTVR0.chl" at block 0 offset 1920 in directory inode 2699352171=20
reference
s free inode 2699400189
         clearing inode number in entry at offset 1920...
         - agno =3D 11
         - agno =3D 12
         - agno =3D 13
         - agno =3D 14
         - agno =3D 15
entry "AdobeFnt00.lst" at block 0 offset 1400 in directory inode=20
4052255567 refe
rences free inode 4050601519
         clearing inode number in entry at offset 1400...
entry "AdobeFnt05.lst" at block 0 offset 2960 in directory inode=20
4052255567 refe
rences free inode 4048724573
         clearing inode number in entry at offset 2960...
entry "AdobeFnt04.lst" at block 0 offset 3072 in directory inode=20
4052255567 refe
rences free inode 4056487992
         clearing inode number in entry at offset 3072...
         - agno =3D 16
         - agno =3D 17
         - agno =3D 18
         - agno =3D 19
         - agno =3D 20
         - agno =3D 21
         - agno =3D 22
         - agno =3D 23
         - agno =3D 24
         - agno =3D 25
         - agno =3D 26
         - agno =3D 27
         - agno =3D 28
         - agno =3D 29
         - agno =3D 30
         - agno =3D 31
Phase 5 - rebuild AG headers and trees...
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - ensuring existence of lost+found directory
         - traversing filesystem starting at / ...
rebuilding directory inode 128
rebuilding directory inode 536909609
rebuilding directory inode 1073782824
rebuilding directory inode 1073771053
rebuilding directory inode 2699352171
rebuilding directory inode 1610654999
entry "settings.xml" in shortform directory inode 268470425 points to=20
free inode
  268491301
junking entry "settings.xml" in directory inode 268491301
rebuilding directory inode 39152
rebuilding directory inode 1073771423
rebuilding directory inode 4052255567
entry "settings.sol" in shortform directory inode 1073765024 points to=20
free inod
e 1073765375
junking entry "settings.sol" in directory inode 1073765375
rebuilding directory inode 1342192000
         - traversal finished ...
         - traversing all unattached subtrees ...
         - traversals finished ...
         - moving disconnected inodes to lost+found ...
disconnected inode 57710, moving to lost+found
disconnected inode 57811, moving to lost+found
disconnected inode 268483357, moving to lost+found
disconnected inode 536909580, moving to lost+found
disconnected inode 536911218, moving to lost+found
disconnected inode 536931642, moving to lost+found
disconnected inode 536931643, moving to lost+found
disconnected inode 805320139, moving to lost+found
disconnected inode 805321300, moving to lost+found
disconnected inode 1073789249, moving to lost+found
disconnected inode 1073794002, moving to lost+found
disconnected inode 1073794734, moving to lost+found
disconnected inode 1073800857, moving to lost+found
disconnected inode 1073800862, moving to lost+found
disconnected inode 1342188547, moving to lost+found
disconnected inode 1342188653, moving to lost+found
disconnected inode 1342200504, moving to lost+found
disconnected inode 1342200509, moving to lost+found
disconnected inode 1342209771, moving to lost+found
disconnected inode 1342209840, moving to lost+found
disconnected inode 1342209924, moving to lost+found
disconnected inode 1342210023, moving to lost+found
disconnected inode 1342210074, moving to lost+found
disconnected inode 1342219122, moving to lost+found
disconnected inode 1342219310, moving to lost+found
disconnected inode 1342219363, moving to lost+found
disconnected inode 1342219672, moving to lost+found
disconnected inode 1342222775, moving to lost+found
disconnected inode 1342222911, moving to lost+found
disconnected inode 1342222942, moving to lost+found
disconnected inode 1342225917, moving to lost+found
disconnected inode 1342226754, moving to lost+found
disconnected inode 1342227011, moving to lost+found
disconnected inode 1342228292, moving to lost+found
disconnected inode 1342228678, moving to lost+found
disconnected inode 1342229022, moving to lost+found
disconnected inode 1342229043, moving to lost+found
disconnected inode 1342229161, moving to lost+found
disconnected inode 1342229522, moving to lost+found
disconnected inode 1342229554, moving to lost+found
disconnected inode 1342230251, moving to lost+found
disconnected inode 1342230257, moving to lost+found
disconnected inode 1342230281, moving to lost+found
disconnected inode 1342230303, moving to lost+found
disconnected inode 1342230688, moving to lost+found
disconnected inode 1342233033, moving to lost+found
disconnected inode 1342233148, moving to lost+found
disconnected inode 1342233194, moving to lost+found
disconnected inode 1342233208, moving to lost+found
disconnected inode 1342233234, moving to lost+found
disconnected inode 1342233761, moving to lost+found
disconnected inode 1342233778, moving to lost+found
disconnected inode 1342234141, moving to lost+found
disconnected inode 1342234258, moving to lost+found
disconnected inode 1342234266, moving to lost+found
disconnected inode 1610636053, moving to lost+found
disconnected inode 1610654518, moving to lost+found
disconnected inode 1610668967, moving to lost+found
disconnected inode 2699400184, moving to lost+found
disconnected inode 2699400185, moving to lost+found
disconnected inode 4048724570, moving to lost+found
disconnected inode 4050886573, moving to lost+found
disconnected inode 4056744747, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 268483470 nlinks from 1 to 2
resetting inode 805320078 nlinks from 1 to 2
resetting inode 805327953 nlinks from 1 to 2
resetting inode 1073793449 nlinks from 1 to 2
resetting inode 1342188688 nlinks from 1 to 2
resetting inode 1342201396 nlinks from 1 to 2
resetting inode 1342209294 nlinks from 1 to 2
resetting inode 1342209618 nlinks from 1 to 2
resetting inode 1342209654 nlinks from 1 to 2
resetting inode 1342209917 nlinks from 1 to 2
resetting inode 1342210104 nlinks from 1 to 2
resetting inode 1342219214 nlinks from 1 to 2
resetting inode 1342219224 nlinks from 1 to 2
resetting inode 1342219346 nlinks from 1 to 2
resetting inode 1342219390 nlinks from 1 to 2
resetting inode 1342219706 nlinks from 1 to 2
resetting inode 1342219793 nlinks from 1 to 2
resetting inode 1342219978 nlinks from 1 to 2
resetting inode 1342222896 nlinks from 1 to 2
resetting inode 1342222946 nlinks from 1 to 2
resetting inode 1342222955 nlinks from 1 to 2
corrupt dinode 1342225423, extent total =3D 1, nblocks =3D 0.  This is a bu=
g.
Please report it to linux-xfs@oss.sgi.com.

fatal error -- couldn't map inode 1342225423, err =3D 990
linuxserver:/var/log # mount -a


thanks


--
Matthias Cypris
Head IT-Technik / IT-Einkauf
EUROIMMUN AG
Seekamp 31
D-23560 L=FCbeck
Phone:  +49 451 58 55-24351
Fax:    +49 451 58 55-270
m.cypris@euroimmun.de
www.euroimmun.de




--------------ms010902080306040800000406
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEH
AQAAoIIQtDCCBVcwggQ/oAMCAQICEFwdAADLyODHp72ZDe6NVcswDQYJKoZI
hvcNAQEEBQAwggEPMQswCQYDVQQGEwJERTEzMDEGA1UEChMqRVVST0lNTVVO
IE1lZGl6aW5pc2NoZSBMYWJvcmRpYWdub3N0aWthIEFHMR8wHQYDVQQLExZW
ZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNzE1MDMGA1UE
CxMsQ2xhc3MgMiBNYW5hZ2VkIFBLSSBJbmRpdmlkdWFsIFN1YnNjcmliZXIg
Q0ExNjA0BgNVBAMTLUVVUk9JTU1VTiBNZWRpemluaXNjaGUgTGFib3JkaWFn
bm9zdGlrYSBBRyBDQTAeFw0wODEwMTMwMDAwMDBaFw0wOTEwMTMyMzU5NTla
MIHbMQswCQYDVQQGEwJERTEzMDEGA1UECgwqRVVST0lNTVVOIE1lZGl6aW5p
c2NoZSBMYWJvcmRpYWdub3N0aWthIEFHMQ8wDQYDVQQLDAZDQS1TU0wxRjBE
BgNVBAsMPXd3dy52ZXJpc2lnbi5jb20vcmVwb3NpdG9yeS9DUFMgSW5jb3Jw
LiBieSBSZWYuLExJQUIuTFREKGMpOTkxGDAWBgNVBAMMD01hdHRoaWFzIEN5
cHJpczEkMCIGCSqGSIb3DQEJARYVbS5jeXByaXNAZXVyb2ltbXVuLmRlMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm2GIgKWy+6rD0ZKp2cMI
IRRlJqvv/K/wr5s/ypwgldoYgNIYlfxUaGXKrq7OCqxB5EKR63Se4yMFsSoR
3z+9B+l9hLWCu8WJk6L6FQsiSEKtRwLXJBIFDZxUOdc3S4D6nvtT9QRirfz/
CbnTBonBMDA0A+uGvlI9ZN8V7vlZq8jsBBD436s8GAddzUdeOcNXPPkLNQih
Xn8yqeFUirVm47HREaLdUU7IUhNugui1M+2lzefF6o7TMYpVw1f1ldYwHzxY
r4ehRKOnwBWi90BrehSoTx6ubhmpdSSL9EOnKGmzWpBsO9bm7iknxOj3R+zk
VHndf09XFmgbxM2OzkJUFwIDAQABo4HfMIHcMAkGA1UdEwQCMAAwRAYDVR0g
BD0wOzA5BgtghkgBhvhFAQcXAjAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3
dy52ZXJpc2lnbi5jb20vcnBhMAsGA1UdDwQEAwIFoDARBglghkgBhvhCAQEE
BAMCB4AwaQYDVR0fBGIwYDBeoFygWoZYaHR0cDovL29uc2l0ZWNybC52ZXJp
c2lnbi5jb20vRVVST0lNTVVOTWVkaXppbmlzY2hlTGFib3JkaWFnbm9zdGlr
YUFHQ0FTU0wvTGF0ZXN0Q1JMLmNybDANBgkqhkiG9w0BAQQFAAOCAQEAY/fg
4SDvYG912wGX9AEqMJ4c0jttrr1Odx73/8U7mmVLM0bcikEB2i2K7OHaEmAq
5effzY5btGIvc9nNRBlvcLq5iizK3bvPWnZ6Y4KsAKVqyA5hxkFJiivzCGZo
sKDW4qEqTPg8xhZN/oeWzWqB0Y2HkzTc0PZENXN1iXC00LfcmPFvk8GWwPby
Rh9SCLDxBzDUqq5suGyUty5Zj+Y17IAdqiDZZa9E3NHGlWgyjmDGhhwSSzvY
Y/KldpaQlr9wMt18AqDBECSY7hsHKsOv5KcvBhc+EJwJMEhSLSPJPfmDKeve
mdEAqfonHD/s+CbUxiAYKSSA9lstmlUJxETj7TCCBVcwggQ/oAMCAQICEFwd
AADLyODHp72ZDe6NVcswDQYJKoZIhvcNAQEEBQAwggEPMQswCQYDVQQGEwJE
RTEzMDEGA1UEChMqRVVST0lNTVVOIE1lZGl6aW5pc2NoZSBMYWJvcmRpYWdu
b3N0aWthIEFHMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTsw
OQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24u
Y29tL3JwYSAoYykwNzE1MDMGA1UECxMsQ2xhc3MgMiBNYW5hZ2VkIFBLSSBJ
bmRpdmlkdWFsIFN1YnNjcmliZXIgQ0ExNjA0BgNVBAMTLUVVUk9JTU1VTiBN
ZWRpemluaXNjaGUgTGFib3JkaWFnbm9zdGlrYSBBRyBDQTAeFw0wODEwMTMw
MDAwMDBaFw0wOTEwMTMyMzU5NTlaMIHbMQswCQYDVQQGEwJERTEzMDEGA1UE
CgwqRVVST0lNTVVOIE1lZGl6aW5pc2NoZSBMYWJvcmRpYWdub3N0aWthIEFH
MQ8wDQYDVQQLDAZDQS1TU0wxRjBEBgNVBAsMPXd3dy52ZXJpc2lnbi5jb20v
cmVwb3NpdG9yeS9DUFMgSW5jb3JwLiBieSBSZWYuLExJQUIuTFREKGMpOTkx
GDAWBgNVBAMMD01hdHRoaWFzIEN5cHJpczEkMCIGCSqGSIb3DQEJARYVbS5j
eXByaXNAZXVyb2ltbXVuLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAm2GIgKWy+6rD0ZKp2cMIIRRlJqvv/K/wr5s/ypwgldoYgNIYlfxU
aGXKrq7OCqxB5EKR63Se4yMFsSoR3z+9B+l9hLWCu8WJk6L6FQsiSEKtRwLX
JBIFDZxUOdc3S4D6nvtT9QRirfz/CbnTBonBMDA0A+uGvlI9ZN8V7vlZq8js
BBD436s8GAddzUdeOcNXPPkLNQihXn8yqeFUirVm47HREaLdUU7IUhNugui1
M+2lzefF6o7TMYpVw1f1ldYwHzxYr4ehRKOnwBWi90BrehSoTx6ubhmpdSSL
9EOnKGmzWpBsO9bm7iknxOj3R+zkVHndf09XFmgbxM2OzkJUFwIDAQABo4Hf
MIHcMAkGA1UdEwQCMAAwRAYDVR0gBD0wOzA5BgtghkgBhvhFAQcXAjAqMCgG
CCsGAQUFBwIBFhxodHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhMAsGA1Ud
DwQEAwIFoDARBglghkgBhvhCAQEEBAMCB4AwaQYDVR0fBGIwYDBeoFygWoZY
aHR0cDovL29uc2l0ZWNybC52ZXJpc2lnbi5jb20vRVVST0lNTVVOTWVkaXpp
bmlzY2hlTGFib3JkaWFnbm9zdGlrYUFHQ0FTU0wvTGF0ZXN0Q1JMLmNybDAN
BgkqhkiG9w0BAQQFAAOCAQEAY/fg4SDvYG912wGX9AEqMJ4c0jttrr1Odx73
/8U7mmVLM0bcikEB2i2K7OHaEmAq5effzY5btGIvc9nNRBlvcLq5iizK3bvP
WnZ6Y4KsAKVqyA5hxkFJiivzCGZosKDW4qEqTPg8xhZN/oeWzWqB0Y2HkzTc
0PZENXN1iXC00LfcmPFvk8GWwPbyRh9SCLDxBzDUqq5suGyUty5Zj+Y17IAd
qiDZZa9E3NHGlWgyjmDGhhwSSzvYY/KldpaQlr9wMt18AqDBECSY7hsHKsOv
5KcvBhc+EJwJMEhSLSPJPfmDKevemdEAqfonHD/s+CbUxiAYKSSA9lstmlUJ
xETj7TCCBfowggVjoAMCAQICECZjSxIdY4C6FmCvxt2LQBgwDQYJKoZIhvcN
AQEFBQAwgcExCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5j
LjE8MDoGA1UECxMzQ2xhc3MgMiBQdWJsaWMgUHJpbWFyeSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eSAtIEcyMTowOAYDVQQLEzEoYykgMTk5OCBWZXJpU2ln
biwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MR8wHQYDVQQLExZW
ZXJpU2lnbiBUcnVzdCBOZXR3b3JrMB4XDTA3MTAwMjAwMDAwMFoXDTEyMTAw
MTIzNTk1OVowggEPMQswCQYDVQQGEwJERTEzMDEGA1UEChMqRVVST0lNTVVO
IE1lZGl6aW5pc2NoZSBMYWJvcmRpYWdub3N0aWthIEFHMR8wHQYDVQQLExZW
ZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNzE1MDMGA1UE
CxMsQ2xhc3MgMiBNYW5hZ2VkIFBLSSBJbmRpdmlkdWFsIFN1YnNjcmliZXIg
Q0ExNjA0BgNVBAMTLUVVUk9JTU1VTiBNZWRpemluaXNjaGUgTGFib3JkaWFn
bm9zdGlrYSBBRyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
ANriZ1cerNK+gWKAYPGX8yJ/E06/N8xcXer1cte/wnGZUXf3Q51Zgn5aDV9g
M4seBdxwD2tGBIvG/5Ec2MKoF5SK+Ug/vvfIdTkzY7FqFHrf9iRGxEQ0KvtC
8B8PQi1JOGSYT44S+8OKp4+q+hWNnHPOXGluafFAiPy1iXhaYQ9PO1x4zEv+
UPZNnRFNgPU2OXONODTMzClvycn02jQchcC8re81qD6a28/5gSJmJJE6M/Cw
Elkj5T9PHuoP7Fsh4lSDrBhF0roRhPnqu5MfjMyIeQI2asuEwqZNeGb7kglc
/FGuMzALgjgnrw2pX039N3ps/Z3Khfy7/Sk2vca66OECAwEAAaOCAhwwggIY
MBIGA1UdEwEB/wQIMAYBAf8CAQAwNAYDVR0fBC0wKzApoCegJYYjaHR0cDov
L2NybC52ZXJpc2lnbi5jb20vcGNhMi1nMi5jcmwwEQYJYIZIAYb4QgEBBAQD
AgEGMA4GA1UdDwEB/wQEAwIBBjBwBgNVHSAEaTBnMGUGC2CGSAGG+EUBBxcC
MFYwKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9jcHMw
KgYIKwYBBQUHAgIwHhocaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYTAt
BgNVHREEJjAkpCIwIDEeMBwGA1UEAxMVUHJpdmF0ZUxhYmVsNC0yMDQ4LTQ4
MB0GA1UdDgQWBBQv9pLtCdLEelSoJcpyGfLAFceIxjCB6AYDVR0jBIHgMIHd
oYHHpIHEMIHBMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIElu
Yy4xPDA6BgNVBAsTM0NsYXNzIDIgUHVibGljIFByaW1hcnkgQ2VydGlmaWNh
dGlvbiBBdXRob3JpdHkgLSBHMjE6MDgGA1UECxMxKGMpIDE5OTggVmVyaVNp
Z24sIEluYy4gLSBGb3IgYXV0aG9yaXplZCB1c2Ugb25seTEfMB0GA1UECxMW
VmVyaVNpZ24gVHJ1c3QgTmV0d29ya4IRALkvYMyIn6F6Rgm4W3Bsiq8wDQYJ
KoZIhvcNAQEFBQADgYEAAMG9LQggZUot2APn8o8yG5wNyvmhBclQH/AsuEcM
qMrEDJs3/JeKDqWMCJlrH4XC03Uxj5rHRbmedRxKQJ1uQdwWSRmsHIF/s24w
q7FzgYxaMTiywCO2FJBTk/XJBPzov2Rme0Cc3U0npi0CSuYfyfsjIaJn+24t
MwdwGcQj/90xggV9MIIFeQIBATCCASUwggEPMQswCQYDVQQGEwJERTEzMDEG
A1UEChMqRVVST0lNTVVOIE1lZGl6aW5pc2NoZSBMYWJvcmRpYWdub3N0aWth
IEFHMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQL
EzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3Jw
YSAoYykwNzE1MDMGA1UECxMsQ2xhc3MgMiBNYW5hZ2VkIFBLSSBJbmRpdmlk
dWFsIFN1YnNjcmliZXIgQ0ExNjA0BgNVBAMTLUVVUk9JTU1VTiBNZWRpemlu
aXNjaGUgTGFib3JkaWFnbm9zdGlrYSBBRyBDQQIQXB0AAMvI4MenvZkN7o1V
yzAJBgUrDgMCGgUAoIIDKzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0wODEyMjQxMDE3MTdaMCMGCSqGSIb3DQEJBDEWBBRg
EZJLrftx+Io3hB2I5Sq5tkxPqDBSBgkqhkiG9w0BCQ8xRTBDMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzAN
BggqhkiG9w0DAgIBKDCCATgGCSsGAQQBgjcQBDGCASkwggElMIIBDzELMAkG
A1UEBhMCREUxMzAxBgNVBAoTKkVVUk9JTU1VTiBNZWRpemluaXNjaGUgTGFi
b3JkaWFnbm9zdGlrYSBBRzEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0
d29yazE7MDkGA1UECxMyVGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZl
cmlzaWduLmNvbS9ycGEgKGMpMDcxNTAzBgNVBAsTLENsYXNzIDIgTWFuYWdl
ZCBQS0kgSW5kaXZpZHVhbCBTdWJzY3JpYmVyIENBMTYwNAYDVQQDEy1FVVJP
SU1NVU4gTWVkaXppbmlzY2hlIExhYm9yZGlhZ25vc3Rpa2EgQUcgQ0ECEFwd
AADLyODHp72ZDe6NVcswggE6BgsqhkiG9w0BCRACCzGCASmgggElMIIBDzEL
MAkGA1UEBhMCREUxMzAxBgNVBAoTKkVVUk9JTU1VTiBNZWRpemluaXNjaGUg
TGFib3JkaWFnbm9zdGlrYSBBRzEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3Qg
TmV0d29yazE7MDkGA1UECxMyVGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3
LnZlcmlzaWduLmNvbS9ycGEgKGMpMDcxNTAzBgNVBAsTLENsYXNzIDIgTWFu
YWdlZCBQS0kgSW5kaXZpZHVhbCBTdWJzY3JpYmVyIENBMTYwNAYDVQQDEy1F
VVJPSU1NVU4gTWVkaXppbmlzY2hlIExhYm9yZGlhZ25vc3Rpa2EgQUcgQ0EC
EFwdAADLyODHp72ZDe6NVcswDQYJKoZIhvcNAQEBBQAEggEAZzBI7x1b9YAK
9Ox6nS9sOgrMYh8TKST6cdao0Objhw1uImKKzfLjr0ehz1l34QVV7DLbL2K9
972l6ox2LrJUTgcMLkCXj84YFb5UW8QcdLn12dTdYN8v07i7Z2YxZRsN9zrA
8knlHKvHdp3Ew63cXrg8BcTf69HZotimjL2Zrghjh1tyBuzb1kIA2F5sAZRK
g/Q0igggpkYS4eTrcD3yX/6/IBv5SyWBGSjp6fCOctvy3/JOFAYjiKQXARFs
XAK9e0ZKe9bR/QhoGKv5fN8XBzrmEPvzzoBiBn+r2KizMwUGiJcgzwoFDy5E
atZXAt+IIDErgoD7O/ObUw6wEFTxdwAAAAAAAA==

--------------ms010902080306040800000406--


--===============0436498388226529805==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0436498388226529805==--
