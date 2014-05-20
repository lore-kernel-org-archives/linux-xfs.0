Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE6737F54
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 22:35:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8AAA8F8039
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 20:35:18 -0700 (PDT)
Received: from muffat.debian.org (muffat.debian.org [206.12.19.146]) by
	cuda.sgi.com with ESMTP id eaH5Ln5RkqVMNd5u (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 20:35:17 -0700 (PDT)
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
MIME-Version: 1.0
Subject: xfsprogs_3.2.0_i386.changes ACCEPTED into unstable
Message-Id: <E1Wmape-0002Gz-E9@franck.debian.org>
Date: Tue, 20 May 2014 03:35:14 +0000
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
Hash: SHA1

Format: 1.8
Date: Sat, 03 May 2014 15:59:55 +1000
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source i386
Version: 3.2.0
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Nathan Scott <nathans@debian.org>
Description: 
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Closes: 725971
Changes: 
 xfsprogs (3.2.0) unstable; urgency=low
 .
   * New upstream release
   * Add dh-autoreconf invocation (closes: #725971)
Checksums-Sha1: 
 3904d254c33d3188aa50f8ec3a2def7de14ca46b 1154 xfsprogs_3.2.0.dsc
 b17b19e09acf84918410511cc3066d96691df7a3 1475505 xfsprogs_3.2.0.tar.gz
 9d4fba1bc045ee7ec2798a714fd5e4e0b0947b9e 715846 xfsprogs_3.2.0_i386.deb
 0bea595db0b5fd5694fa00fc0ebf85b80b1e96e2 31688 xfslibs-dev_3.2.0_i386.deb
 913118e221529719fc8b2f74f6cdb696f51ecd07 144454 xfsprogs-udeb_3.2.0_i386.udeb
Checksums-Sha256: 
 7eb8ed25b68d7010ed8bfbd14ad7f28e7906754021b4803859f3f19c21c0e1e2 1154 xfsprogs_3.2.0.dsc
 2fc7e7eeb62d75dd75591ff0b12332ab5c5a401e7124d45348d8cb50f02190ea 1475505 xfsprogs_3.2.0.tar.gz
 20c6a4bb1892d4f20f8104c686f09d2bfde4646b1e359aeccdbcffbbbc3c49fc 715846 xfsprogs_3.2.0_i386.deb
 c39d46510bb5fa2f1727817eebe0d0c439d5f88e9828c58da0fc3e099e53f47b 31688 xfslibs-dev_3.2.0_i386.deb
 895a39751d0bc473a87640a2ed4bbcb065334d2f3e7e94c70937463aabb86aa5 144454 xfsprogs-udeb_3.2.0_i386.udeb
Files: 
 02eb7572d6021b9dfa66829f5c09b76a 715846 admin optional xfsprogs_3.2.0_i386.deb
 ccadbf82194fcd782bb00fbfccf5cd12 31688 libdevel extra xfslibs-dev_3.2.0_i386.deb
 db69bbf7b3d16d7d9eefa8c83fdb6b55 144454 debian-installer optional xfsprogs-udeb_3.2.0_i386.udeb
 41293c850dec5d78a4d487425206606a 1154 admin optional xfsprogs_3.2.0.dsc
 9f81cdc305dfe6957da74df8a42eb8b2 1475505 admin optional xfsprogs_3.2.0.tar.gz
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlN5fpYACgkQm8fl3HSIa2N1kwCePahqgf5eVqKoiwu6/9DsfFMU
SnMAn3LqkbZOMIn49maH6pVFTDPo5u0c
=julc
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
