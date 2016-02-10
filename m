Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 695AE29DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 22:08:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01A86AC008
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 20:08:00 -0800 (PST)
Received: from muffat.debian.org (muffat.debian.org [206.12.19.146]) by
	cuda.sgi.com with ESMTP id qPFfZKGBh48mCKd3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 20:07:58 -0800 (PST)
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
MIME-Version: 1.0
Subject: xfsprogs_4.3.0+nmu1_amd64.changes ACCEPTED into unstable
Message-Id: <E1aTM4K-0005Sp-77@franck.debian.org>
Date: Wed, 10 Feb 2016 04:07:56 +0000
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS Development Team <xfs@oss.sgi.com>, Marco d'Itri <md@linux.it>



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Wed, 10 Feb 2016 04:24:23 +0100
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source amd64
Version: 4.3.0+nmu1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Marco d'Itri <md@linux.it>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Closes: 766811
Changes:
 xfsprogs (4.3.0+nmu1) unstable; urgency=medium
 .
   * Non-maintainer upload.
   * Disabled the code in include/buildmacros which creates bogus symlinks
     for libraries. (Closes: #766811)
Checksums-Sha1:
 e7ab9e37de40b7ec796ee7699202d7694b82c449 1612 xfsprogs_4.3.0+nmu1.dsc
 da46a0c33d081895e84a8f08f4e5d9b088bb91ca 1525950 xfsprogs_4.3.0+nmu1.tar.gz
 6786a598e9718db2e871059059709c6fad0c5987 55278 xfslibs-dev_4.3.0+nmu1_amd64.deb
 5cf3ce94ed683cdcece29acebdc72bdac6a63d27 4415864 xfsprogs-dbgsym_4.3.0+nmu1_amd64.deb
 7e408685693cea85b70339498e98306192ca1efc 134984 xfsprogs-udeb_4.3.0+nmu1_amd64.udeb
 32fd66e743c994d077e01786fc80c11ee9571163 725966 xfsprogs_4.3.0+nmu1_amd64.deb
Checksums-Sha256:
 f46c7321b01c967a7c0aeccc730c3341288c15209c96907e88eb7cc77e3189d5 1612 xfsprogs_4.3.0+nmu1.dsc
 441865bccd805797456093df460e42635b0e7bf8a2e091d17cbd3093655af5cc 1525950 xfsprogs_4.3.0+nmu1.tar.gz
 d521a17c64282f82768ca07005840c230e187b9eaeea5aa49d1e919388f1fbf9 55278 xfslibs-dev_4.3.0+nmu1_amd64.deb
 9d8f43a1ee55d8240c9e93152e1e0c1c37319db19658de5efd3e0882c9b59c17 4415864 xfsprogs-dbgsym_4.3.0+nmu1_amd64.deb
 f23fbaa4475b2acd79fa2a1c455c671a3b0af4907b8689be8b44f96e456196fb 134984 xfsprogs-udeb_4.3.0+nmu1_amd64.udeb
 eda7a21bcc06dc4c5a2615261f0d9ca72f88cb0d050b70cdce7d692c053ec331 725966 xfsprogs_4.3.0+nmu1_amd64.deb
Files:
 1797bb95895c6d50445a918a0c733916 1612 admin optional xfsprogs_4.3.0+nmu1.dsc
 ec2437b96786bf7da8a41d2a8af15906 1525950 admin optional xfsprogs_4.3.0+nmu1.tar.gz
 9e5f82404556827506c5a8b6ad548b3b 55278 libdevel extra xfslibs-dev_4.3.0+nmu1_amd64.deb
 30a43366db62eba660507e7bb0101593 4415864 debug extra xfsprogs-dbgsym_4.3.0+nmu1_amd64.deb
 03e5cc5a89a8b8240ae41348a2fa4de4 134984 debian-installer optional xfsprogs-udeb_4.3.0+nmu1_amd64.udeb
 52343e93d42bcdb5e53ba28c30224a97 725966 admin optional xfsprogs_4.3.0+nmu1_amd64.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQGcBAEBCAAGBQJWurH+AAoJECv1pcEixPekchgMAIyQSNEE2EV7zpYyZRTdrD/J
NqsoYfA7nEUMt+n3lcJBnqEKthcxyljRYpaBW96fFm5SMToe45mW0GR8QRW9tFGu
top9SDXplKQVKNbCUv9BJRVtH5JOufducppVuD21XIPu7uB8FKwDHuYSDdta+UW3
bT31RQ6KLxHGvNoFeMljbscmarVeKioVo8G3BrJGOEnxv3Vfy/JBJXp/jnCmNz7z
lCCkDUnAf4qZAjJ7FgxKC90SC42KyU42Cw6h2BmVVlT9zfqdzBnBqZmTQsvMJF2+
BlovBJ69JOrwy68tr9mmpbE0vcnCgakYid3h+TaAg0DBJDkVeR2llTwlN93dLGDl
tyou6Yyt+LCT1iTqXnhSY1U2W5T0xHYpW4OARTLvXC4nHb7Tbw5SVyjlrEEMGLCx
0HFAeH1ksV4mK6xMokA814MMBavwmUMXa7VYIrQa4qeVriqrDVMmZNrO1guaNgzI
WObmEFg89xJ8c/wC76B8BJgdKDrIhRe9YIhIZ3pN8A==
=j4S+
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
