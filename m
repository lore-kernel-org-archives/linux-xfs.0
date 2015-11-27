Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CED187F37
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 18:51:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEBB9304039
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 16:51:01 -0800 (PST)
Received: from mailly.debian.org (mailly.debian.org [82.195.75.114]) by
	cuda.sgi.com with ESMTP id mvd92gjaQqcsdSvM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2015 16:50:59 -0800 (PST)
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
MIME-Version: 1.0
Subject: xfsprogs_4.3.0_amd64.changes ACCEPTED into unstable
Message-Id: <E1a27FX-0002su-92@franck.debian.org>
Date: Fri, 27 Nov 2015 00:50:55 +0000
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
Date: Mon, 23 Nov 2015 15:22:56 +1100
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source amd64
Version: 4.3.0
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Closes: 804255
Changes:
 xfsprogs (4.3.0) unstable; urgency=low
 .
   * New upstream release
   * Add a postinst to update the initramfs on install/upgrade.
     (Closes: #804255)
Checksums-Sha1:
 31064221f22a5b20c731e9e3710bf1d6de759341 1763 xfsprogs_4.3.0.dsc
 cc5e4c06f537de9b9903b29f761c1b7534876b17 1506750 xfsprogs_4.3.0.tar.gz
 003e83012c59d84ca33850c1d29b59034397bda9 55212 xfslibs-dev_4.3.0_amd64.deb
 379252c78d7eb0dd643f0d136e7db13eabd548bc 134808 xfsprogs-udeb_4.3.0_amd64.udeb
 270c3c737ffe7916d9b230e75415a05b46857928 727106 xfsprogs_4.3.0_amd64.deb
Checksums-Sha256:
 84daf22e23b846ea319a1707d0b79eb2b61f869531ce27d2cfd42e716cf8265a 1763 xfsprogs_4.3.0.dsc
 a914e45648e04d211304ffd9fadba919be9d66010ec7b19dffad356c8cbf969e 1506750 xfsprogs_4.3.0.tar.gz
 233aae38eead8db27346dccd560d7eef1ab5c976df2495f5643a20975223f805 55212 xfslibs-dev_4.3.0_amd64.deb
 c8e540fce739a617fd2ff7b8e4a8e86d0cfb27a25fa50b04c3ac21dc5bc0ae64 134808 xfsprogs-udeb_4.3.0_amd64.udeb
 d8cfef3519c98be8e999b1537b6eb57b8b7925a2715b7cc3a7c55d5e642e3a01 727106 xfsprogs_4.3.0_amd64.deb
Files:
 fc99694150b586161106823f245bea72 1763 admin optional xfsprogs_4.3.0.dsc
 2a6d2918d8a8a89e6816e0476aa3f316 1506750 admin optional xfsprogs_4.3.0.tar.gz
 4a1dd6248c49586edd2081c5c58f1992 55212 libdevel extra xfslibs-dev_4.3.0_amd64.deb
 16394c61c03586daba2fc87f68ad386f 134808 debian-installer optional xfsprogs-udeb_4.3.0_amd64.udeb
 215fad11dceaeea00cffa2ccabefac2b 727106 admin optional xfsprogs_4.3.0_amd64.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWV6TdAAoJEP4IQu423YwMF4kP/1CNyghG5Q1Fk3x2P1FUxx5N
4VaANMpUHRTAuPi0r2dRPQehKqeSfnhgMEzREx44eJOS1SgRcwfu6Cls2Hzv9jn0
/pbqVRe3b7Enovb1UQ9Ibfbo3JdqbgYhkEwFCtO4drgYPilT3+Lv9dtTp4WrfEtq
zOosPYTU+rsidGkEnLdIojL3yIBxsEVjpOWst3LZKzfpE9Ei8xrELApGYB31+cOT
gSWHdlP1C+x6rtAj0lHHvl5MXn/4izRwUsPSKNNqtthp1fcvRcfhXCYpxlpTvmjM
YnfOOkYhH3k1zi4QzdpsFJOWlF5QgwoJPy575+v9v1PpN4rov+re4/dbbdwjG+nR
/inX+wfw+3NxN9jzD6S6kLQh5oPwGbhQgsaSqwkNd4XqpAbRCyX3LvoYTUOgpsPW
yRP3XlJ0nnoFGSBlcltOAQvVIE7fPCebpE2hcO5B4gvVb5O0VRH+N0YxcavwjpPU
pG8uqBixzqEvhL+uXZv1MfZMK9WWB912KhK/fErMP5tty/ln+j/eLJ7bBha54MYE
G0FU2YprwVp3JBy9GWTmgn7Id4CWftFNYQgEcW/nu/zpXDhmtUor8rdLrbVivnKW
8IcB7SXyN9JMckLhozncOsPmvlS7XKUTKdHB5jvAfRdgioGt+ofwPZRROtqOuYbg
P4sV4o6ipK7CyrpzHswD
=d896
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
