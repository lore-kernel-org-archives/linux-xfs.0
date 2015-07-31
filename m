Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 837097F62
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 23:49:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AFD9304032
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 21:49:14 -0700 (PDT)
Received: from muffat.debian.org (muffat.debian.org [206.12.19.146]) by
	cuda.sgi.com with ESMTP id 94nvubYZP6j6wNOs (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 21:49:12 -0700 (PDT)
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
MIME-Version: 1.0
Subject: xfsprogs_3.2.4_i386.changes ACCEPTED into unstable
Message-Id: <E1ZL2Fq-0006xS-T2@franck.debian.org>
Date: Fri, 31 Jul 2015 04:49:10 +0000
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
To: XFS Development Team <xfs@oss.sgi.com>, Nathan Scott <nathans@debian.org>



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Wed, 29 Jul 2015 15:31:27 +1000
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source i386
Version: 3.2.4
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Changes:
 xfsprogs (3.2.4) unstable; urgency=low
 .
   * New upstream release
   * Fix xfs_metadump information leak (CVE-2012-2150)
Checksums-Sha1:
 dfad01179b3c16313265194bf563ff1f041770a2 1780 xfsprogs_3.2.4.dsc
 459f0194b08b579cf13592952b9e4ae650e86918 1494705 xfsprogs_3.2.4.tar.gz
 58a22015fa94c121c0b16d80a9df2d7401ea58c3 726844 xfsprogs_3.2.4_i386.deb
 20ebe019f1268203394e81c7079dabb3b5d459de 31874 xfslibs-dev_3.2.4_i386.deb
 01e166e75ef74920ade099a7b88505ccf5bfd327 146036 xfsprogs-udeb_3.2.4_i386.udeb
Checksums-Sha256:
 8fc122a88c6995aca119bf1e904b856cd07b1bce9a9c61589e013884e84c36cc 1780 xfsprogs_3.2.4.dsc
 3017ef58193b064e1e6042ff4648387259bb3e5d9d0f2a941c00bc62ab2a7634 1494705 xfsprogs_3.2.4.tar.gz
 5a771107dd1fafb9b8238bca81d194083089bd6edeed9ebeb4ec1ee957d75749 726844 xfsprogs_3.2.4_i386.deb
 02ea6f248747b19f03f1efff80539027eeb1e61c67c2b91d89ad47c1c86fb3b0 31874 xfslibs-dev_3.2.4_i386.deb
 0ea81572f79d62707f4ced6a7a05b24f103f85a6a6e85130e9e0f084c194e7c1 146036 xfsprogs-udeb_3.2.4_i386.udeb
Files:
 6100348b033b11e34e58907551f7db13 1780 admin optional xfsprogs_3.2.4.dsc
 f78e169728f4156645fc37e95da5f020 1494705 admin optional xfsprogs_3.2.4.tar.gz
 71968e8300fe186539fbda44bfab49e3 726844 admin optional xfsprogs_3.2.4_i386.deb
 998f5a0b8fb21eee5ce6ef4e03cea1f9 31874 libdevel extra xfslibs-dev_3.2.4_i386.deb
 3a46ad4f9afd807a3b5019ee7c4929a4 146036 debian-installer optional xfsprogs-udeb_3.2.4_i386.udeb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJVudoFAAoJEP4IQu423YwM02UP/jpgT3u60xnf7UxeJXazoDFV
JWRKie39YyXL0IOWqa/+mbBTFr7w6AXIHx7bVvec6uqYf/jhOjzfbqf7mMt99/4C
WaDz7mb/ty44ZFpWJiC00QH6xJfhNe328KPgL1+7rLKi0+3ABmiIX+SL2uzaftWK
HlJLw53jm6yCrACbbZD5Sz9hkVm8IGz+RT5F4yLUhmR54q13Pu7WDdQoUy5FmbE6
WfWRtwOPAuGusejkkHByqhm+En1O9ewLqGu1AbQW1DnpfI8jklRXRA9XS7rxO4ee
H5VYK/CodKjxR2v21Ycv/Dc8Jl5esfSrZ2xEorG0wI7oPdaKgxi8tg8ZpnOC1MiE
Acii0q14S2dDDYPjpmlcbxrHa42rShjwMduiKk57E912Cq2PtSiJbf3+OkxK1wKi
MJzqKGQMgMD5K9me4fThH4n7cJMaAq/05+ceNTOQ67JV6mofwdNHZboOi2NHiCy6
KJISdHcBnFp+ZvKanQ3BHQaXHR1rJahyyKcFamYg7t1Aiezk8WOCBoz++s+JWkuE
FP/pbUDcO7BE/C3xB+lui8Los9DjbFNrwuWEaqvB1Tjj79ZaauVhNIu7Od7VngqP
aPgoUFp4YAj+gPMjuTRffnkIv0xMn0CdtKr782BvReFGojvke3uBu+0UDcVEl5Ol
6uM99/vp887ySlSB0X1z
=k75m
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
