Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6DBC432C0
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 04:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C27BE207DD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 04:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLDEfu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 23:35:50 -0500
Received: from muffat.debian.org ([209.87.16.33]:49952 "EHLO muffat.debian.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfLDEfu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Dec 2019 23:35:50 -0500
Received: from fasolo.debian.org ([138.16.160.17]:55248)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1icMOC-0002J5-KF; Wed, 04 Dec 2019 04:35:48 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.89)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1icMOB-000GUT-Ck; Wed, 04 Dec 2019 04:35:47 +0000
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
Subject: xfsprogs_5.3.0-1_amd64.changes ACCEPTED into unstable
Message-Id: <E1icMOB-000GUT-Ck@fasolo.debian.org>
Date:   Wed, 04 Dec 2019 04:35:47 +0000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 15 Nov 2019 14:57:03 -0500
Source: xfsprogs
Binary: xfslibs-dev xfsprogs xfsprogs-dbgsym xfsprogs-udeb
Architecture: source amd64
Version: 5.3.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Changes:
 xfsprogs (5.3.0-1) unstable; urgency=low
 .
   * New upstream release
Checksums-Sha1:
 02c9022c3346d1e391cd22041e0f064c3d1426a5 2106 xfsprogs_5.3.0-1.dsc
 22091487829af9038185ca63f660dd63c0065a8f 1829797 xfsprogs_5.3.0.orig.tar.gz
 d5b40a257225a030f0d4bd4fb5cc919cb42005a8 9492 xfsprogs_5.3.0-1.debian.tar.xz
 b5e4ec68981944a38b9e11d16763152d934ba120 109884 xfslibs-dev_5.3.0-1_amd64.deb
 97cf47313f37dc5c824453a5c7e1f16364eb210d 5237788 xfsprogs-dbgsym_5.3.0-1_amd64.deb
 bf06e28a2c23b922aa2a8b44128334f7912ad934 132748 xfsprogs-udeb_5.3.0-1_amd64.udeb
 1125b2528eb11b2ce968bf547b7ece4de256c76f 7551 xfsprogs_5.3.0-1_amd64.buildinfo
 d371f63132e3092c687184a7c3224f9a43e6fc91 921800 xfsprogs_5.3.0-1_amd64.deb
Checksums-Sha256:
 0966bdee7bd1a1d2c6eb53495204ec17c03662bb71eed18d80a9ad79cbac078a 2106 xfsprogs_5.3.0-1.dsc
 9620a3b1c1e93a3c5be52358da8d3cb38bda5acecb36396bc12056f9ac892cd7 1829797 xfsprogs_5.3.0.orig.tar.gz
 557454fabcd715df866043c48d4cdfd751956afdb7ba06bafac50abf3a789a8e 9492 xfsprogs_5.3.0-1.debian.tar.xz
 34fd5a217460324c4a2b5e9e0d4ed663a883c91e3f15d7cffa525a153ee00f4a 109884 xfslibs-dev_5.3.0-1_amd64.deb
 abe47d76be646d1b0b809d7236dc00d4ebaee7a209f8ea9d14d00fa5c4746feb 5237788 xfsprogs-dbgsym_5.3.0-1_amd64.deb
 e86df12361bac61783bc662b317284d7965edfd68bf59685a120e53bc82e57ad 132748 xfsprogs-udeb_5.3.0-1_amd64.udeb
 3ddebb1b9d634cf10324140d52b7ae9a699802f0518dbd2df250fca51ba37138 7551 xfsprogs_5.3.0-1_amd64.buildinfo
 b8cf87811bdb6b4dd10ace60ebaf5516fd8fc9bfb7c6306817fb700400e73979 921800 xfsprogs_5.3.0-1_amd64.deb
Files:
 1c45e100f229c2ea93ffb0f3efa4e78c 2106 admin optional xfsprogs_5.3.0-1.dsc
 f25ebd1ea97abce3304e83d8566d3d9a 1829797 admin optional xfsprogs_5.3.0.orig.tar.gz
 ac64dcb8350c724c2b9e1ef26d63498d 9492 admin optional xfsprogs_5.3.0-1.debian.tar.xz
 7e5f33e90319972ded63bf6d4d1f8203 109884 libdevel extra xfslibs-dev_5.3.0-1_amd64.deb
 5101f628e4b6ee7e7530a0eca633febf 5237788 debug optional xfsprogs-dbgsym_5.3.0-1_amd64.deb
 743984caeee69438e2b094db11658299 132748 debian-installer optional xfsprogs-udeb_5.3.0-1_amd64.udeb
 4972ceff467d359ffe1d946df68110a9 7551 admin optional xfsprogs_5.3.0-1_amd64.buildinfo
 c74ba1839a3064cbbc4e63fc80dc045f 921800 admin optional xfsprogs_5.3.0-1_amd64.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE96vodh5v5oY45ig6/ghC7jbdjAwFAl3nJmMACgkQ/ghC7jbd
jAxC5w//RBxQ42fE2Gp0HYV0RUPTFRGCFautis2enS4X7pkj/6wzRguN5evpbTUe
mrkD6bGb9jwVr/2kve8B2qVA1CaD3eIuRa6Vp1V8mZevKtEknRS6CnJxWrNzpL8t
aw9Yf0duCRuZ5EAeeZLExO5TKeMJuiyeM+xYz4xDzSBDCcrZeK9ixAGCeVBEA+ws
z9XfcHKwTrJf41cUpfaJE/1OZjqUZK42U7rHZ0oaCJBC+xhe+3fGGrUSPN2B5Obr
N0pvf/yLOpqcoUkILNWZjNwfCFDhQs+PL+HM95rhdwjzyGcWkc2Z/7Q8yiCRB8hW
6bxGXrKcDxrPOf6btXD8/Q9yk1h0iIdhJ05/u+2eDwtbi/6W4VNJcIJNrvpugMoP
RI7S4ReqNqdbpC8TM3mLw0t8Hm9MioATmoilZl+Jv+T9tnR2oxrV7LYs8lG82Ee1
qAe4TVGaO59edwlPVMIRIL+371c6pDs4jwdwenWEPkKDtG78an2Vcg67jmdNm4/c
VCHnvzvrCQYmjdg7ESYk9FcDnh+212gwcNF8kXNunXiSwIb6AzjjPBzzWu5ZjY4t
qBcMKIQHJiWjG56lB9rgVqZN750QN9IMaBSlIajckcEA5HTAlyDOcUjp/tpKOeJf
RN5WLAFaCtPRkYZIeAHwy35jlqIXtgQQLKuZfDfgv0/2BhTWdXM=
=6gif
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
