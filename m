Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0E6CA9ECF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 06:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 869E720578
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 06:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfKDGew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 01:34:52 -0500
Received: from muffat.debian.org ([209.87.16.33]:37494 "EHLO muffat.debian.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbfKDGew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 01:34:52 -0500
X-Greylist: delayed 727 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 01:34:51 EST
Received: from fasolo.debian.org ([138.16.160.17]:33550)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1iRVlD-0004Zm-1d; Mon, 04 Nov 2019 06:22:43 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.89)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1iRVlB-0001wL-IV; Mon, 04 Nov 2019 06:22:41 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.2.1-1_amd64.changes ACCEPTED into unstable
Message-Id: <E1iRVlB-0001wL-IV@fasolo.debian.org>
Date:   Mon, 04 Nov 2019 06:22:41 +0000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Wed, 21 Aug 2019 10:42:23 -0500
Source: xfsprogs
Binary: xfslibs-dev xfsprogs xfsprogs-dbgsym xfsprogs-udeb
Architecture: source amd64
Version: 5.2.1-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Changes:
 xfsprogs (5.2.1-1) unstable; urgency=low
 .
   * New upstream release
Checksums-Sha1:
 b61879c4dc727a816797d1c0debebdbb08547a0e 2092 xfsprogs_5.2.1-1.dsc
 ce6288a246efad4a4e2d73ee3f773b15125d82db 1829151 xfsprogs_5.2.1.orig.tar.gz
 de89081e78be03726fe97c5f4d2a8e68bf2ef17e 9452 xfsprogs_5.2.1-1.debian.tar.xz
 76e6c5b42462176801fd29d51fdad394a9c8b8bf 102584 xfslibs-dev_5.2.1-1_amd64.deb
 cd0791fe608a931479ac921fbab8ee017a848436 63936 xfsprogs-dbgsym_5.2.1-1_amd64.deb
 69ce98b528d19cb766c5348dcd4ad20189475b54 129140 xfsprogs-udeb_5.2.1-1_amd64.udeb
 70b301fe2944ed3fac14b83fdd4c22c5ddf6db53 7186 xfsprogs_5.2.1-1_amd64.buildinfo
 e12d05dcaec0977aaa40a6e28d0c291e9a75fc99 877824 xfsprogs_5.2.1-1_amd64.deb
Checksums-Sha256:
 58515a4cd37192dc33f297e6a8c7bef3329af63e5d1bdb08261a716eb72b9693 2092 xfsprogs_5.2.1-1.dsc
 90aaf9c5623de3fda76501ecf4175cb04c99584a2686132dbdd6087e2c5b2a49 1829151 xfsprogs_5.2.1.orig.tar.gz
 5a22c0e974a19ac9f4125766292f19bab3d95dc2e1946fdb41bd5994f91e7f77 9452 xfsprogs_5.2.1-1.debian.tar.xz
 fe8565dd3348c12b2eabb4c4a98c2157363085a0502950e5dc106ebc41c87a31 102584 xfslibs-dev_5.2.1-1_amd64.deb
 e32ff400b8ed527d34608355e94e5809833fd93540244d59bc4ffc3535ec0212 63936 xfsprogs-dbgsym_5.2.1-1_amd64.deb
 edb8c372ff3f4521ac540b6099eaab5cecc67e0ccf84299cfee906ea46862b21 129140 xfsprogs-udeb_5.2.1-1_amd64.udeb
 eb5b39ae483fb1d6040fb195b3b40fb65fc323f63796f118bfd3e8790f6e5370 7186 xfsprogs_5.2.1-1_amd64.buildinfo
 637a85fb4f60147a0a191d16baac96a9bb8da0ec59bcd5ee66ad1fc500824c2a 877824 xfsprogs_5.2.1-1_amd64.deb
Files:
 ec0dc1a7f0e69e00ffd9c4ecbee0d760 2092 admin optional xfsprogs_5.2.1-1.dsc
 b23590e8f02cb1cf6d3a548236674b7a 1829151 admin optional xfsprogs_5.2.1.orig.tar.gz
 1eb9eeefafec90969ac95820aab6edc2 9452 admin optional xfsprogs_5.2.1-1.debian.tar.xz
 6bf3247e0596adbbd323a6d4b887850e 102584 libdevel extra xfslibs-dev_5.2.1-1_amd64.deb
 aaa53f6dcf834e6909a5d15b76012374 63936 debug optional xfsprogs-dbgsym_5.2.1-1_amd64.deb
 8c0cf70cbed4c406ea0fa195fa4e47f2 129140 debian-installer optional xfsprogs-udeb_5.2.1-1_amd64.udeb
 cb5b5bbed6e3d54cad5b31e44185248f 7186 admin optional xfsprogs_5.2.1-1_amd64.buildinfo
 e8ccaa3fc7ec6d2d465ba3c60f22d634 877824 admin optional xfsprogs_5.2.1-1_amd64.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJdv73XAAoJEP4IQu423YwM59UQAID3FwwZE6fjBUfjYrXFCGfk
fSCdXWuW3w/Dhysnz3ywI4HOL1QAywsXbNiNZ05Eg4b5B13DveF56fMn2URc9Xl5
YkV9aIdBYEdGcU028wzYI2/sfq4OiSwB9HDgagJLYT99RcLF2uUW1n1mSa+pzudR
Y/0y+vuiFv1QhHQAmv0n03BxT9yvckPLQKaPVtDpEWotHhgo+Eu6Yr5M/ZGJ4fp2
KQFXzRU+4zsEqhU1myO/W2+shyYGNxN1yKzjp9LIOr93L/mpm7ulWmgalo/En/lW
VxSxpe/upZsOhaE9U3yZJy3odGrrFGIRHMRYyAN6xxM2REw4IZl9mg5ZrigriuG5
bz6iBc9eQpsaR559wxMIQVX5XgbbsyLcR8n199ZytvKcwmeTHm4ltQJBdN5oNf38
L+MWcYgHbTYzSGn7M/FYddKEtLtQHdvturbzl7LLedyuXN2RR4cllBSFjBfxbMUO
1q9FnsOJyN+jDq94C5s5gL4G7/CKP03KWTCZQwbFh3ZoU1oFvz7YsQcDIT+PpMYg
yUDArXOJIaq7bfzqGH18/YORkZqowzm4XBiVJ4eqD/UnrZL6VybFk0SFPDrAT8xF
AfYiTrUC+s37Px15qFe2dOGmja5nLWl3S4e60sq61BhIvUBNdTCywAOPOWtxq8O5
3csSXungEiwz1JqOlwSr
=1SGd
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
