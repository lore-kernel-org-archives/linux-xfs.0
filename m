Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37252C2BA19
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 01:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1722320728
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 01:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgDXBxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 21:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725913AbgDXBxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 21:53:40 -0400
X-Greylist: delayed 2035 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Apr 2020 18:53:40 PDT
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC33C09B042
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 18:53:40 -0700 (PDT)
Received: from fasolo.debian.org ([138.16.160.17]:53830)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1jRn0K-0004qH-4k; Fri, 24 Apr 2020 01:19:44 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1jRn0J-000BIq-0V; Fri, 24 Apr 2020 01:19:43 +0000
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
Subject: xfsprogs_5.6.0-1_amd64.changes ACCEPTED into unstable
Message-Id: <E1jRn0J-000BIq-0V@fasolo.debian.org>
Date:   Fri, 24 Apr 2020 01:19:43 +0000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 14 Apr 2020 14:28:51 -0500
Source: xfsprogs
Binary: xfslibs-dev xfsprogs xfsprogs-dbgsym xfsprogs-udeb
Architecture: source amd64
Version: 5.6.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Changes:
 xfsprogs (5.6.0-1) unstable; urgency=low
 .
   * New upstream release
Checksums-Sha1:
 683a73f357680d008a07a8e9cc841212b29fe716 2106 xfsprogs_5.6.0-1.dsc
 6caa6b6aa5f51f31781767e4740c316cf4283a05 1853654 xfsprogs_5.6.0.orig.tar.gz
 76c1c1f67a1e4bdc21a52ebef8a8d7c4c1ef0032 9588 xfsprogs_5.6.0-1.debian.tar.xz
 ffbfc4eebcc9667fe23ee826f74e76ba1b31eb4e 110676 xfslibs-dev_5.6.0-1_amd64.deb
 5613e8b5d135cd83236e14b0d5f2b6aaca155b15 4945164 xfsprogs-dbgsym_5.6.0-1_amd64.deb
 fb3b1eae5e1e714dc8b93e16457d5b7db8a37040 134560 xfsprogs-udeb_5.6.0-1_amd64.udeb
 c0b6a128e649afb54015fa146333108539f10c69 7532 xfsprogs_5.6.0-1_amd64.buildinfo
 bc8f97aeda1002b65e7a2ce510e39905bacad1de 930496 xfsprogs_5.6.0-1_amd64.deb
Checksums-Sha256:
 c56e52f4fa00b219960a3c03572d6d530652dacd7e1ab081951642f6256b5b9f 2106 xfsprogs_5.6.0-1.dsc
 65c59c0a0e7bb197b4a24a2c223a728757d2d0c40f4e6aa002f162698d18bd7c 1853654 xfsprogs_5.6.0.orig.tar.gz
 5704b2ca5100ee294d0f5c5d9d459845bee97d95ad2b5acbf2b4df89ee8554ae 9588 xfsprogs_5.6.0-1.debian.tar.xz
 65700ad59c2119b492638adc5f93385778ff4b1a3ad217705e8edd8dc3d6d1c5 110676 xfslibs-dev_5.6.0-1_amd64.deb
 bfaf2b4d29cdfb1597973d69b301223e0a49cf3491fcda60345f8b4aab4b3ff1 4945164 xfsprogs-dbgsym_5.6.0-1_amd64.deb
 6dfd5d200dcb0ac6abd5ee432ee4295f9c22fd49224a55a43cf791614c6178ff 134560 xfsprogs-udeb_5.6.0-1_amd64.udeb
 9869d8d519af2b88064fffa8ee1931f194121464265ef9c7681b048766fff29b 7532 xfsprogs_5.6.0-1_amd64.buildinfo
 2904c7978d1649359dde56ed44ad3f314551c4b3b9589ce8ddb5e90495b1e0b2 930496 xfsprogs_5.6.0-1_amd64.deb
Files:
 6f7d6faa2d0129aeca5d10c7e6ba5fa7 2106 admin optional xfsprogs_5.6.0-1.dsc
 75e8084955c06a44c67e0df4cf122e9b 1853654 admin optional xfsprogs_5.6.0.orig.tar.gz
 d80fdc7e01e0b997e30cc99d5d0bb1c5 9588 admin optional xfsprogs_5.6.0-1.debian.tar.xz
 23d6401567b39f36b7e77c9b93d4761d 110676 libdevel extra xfslibs-dev_5.6.0-1_amd64.deb
 25954b1793799377c6953c53d242eb37 4945164 debug optional xfsprogs-dbgsym_5.6.0-1_amd64.deb
 720bb4377e2eb1b8545dcb74851461d6 134560 debian-installer optional xfsprogs-udeb_5.6.0-1_amd64.udeb
 7a302b3dfe0f30f954d068919a173353 7532 admin optional xfsprogs_5.6.0-1_amd64.buildinfo
 d093bede081d03688835d1714f2a9c24 930496 admin optional xfsprogs_5.6.0-1_amd64.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE96vodh5v5oY45ig6/ghC7jbdjAwFAl6iOIEACgkQ/ghC7jbd
jAwTFg/6Aj8QIoreMoImyOWeDfESwsYZ8McQVwlZ3XYq293dWY1gF0FULpaReOaq
6Y/1wn7A1IxruF4E9f1xcHL+XyuDiXX/LusPcE7h1BiyZ1kaCEgFdhNNUpfK+O62
Kgls1cgRQunAHKtK4Rd96mrwwDaVLGKI3pUWvl9I+ukw3lN/nu+fFHtqrh2nFmmh
SzGkvLTV4JWrx5gTsluIR1gmf+1v4Dy3VY6HjRwtgaAF7/iB5kDDbQicbWSsT/zb
OEjtZOn9a1QDp3bAZk4/yW0bmyVcuv63VSE+rUZy+Q0+CmXn4cWKRZLXIzZWo7y3
kAFA0l8TZ/i+x0BPUWje+/unv6/iimq8jGLimtbzqTI57H6wE/LKF5JoPDaGDD4n
yRtTUTKTWbvlq6WwYzq8tXH6B7VgRf12aJi9Kn02LLqkwI/I+XhSUhvHsXI2zsFQ
4ebtsueLsbZMX8nrAxOOPr1bRKiE7BZvKEnsog3m0q+gQF4i1J1lHrjRsrHE9M98
YkBWbyLN6JZQ390LJ6ei2nDVmfg3qgZsatZrCNRP+kTREsNrwPbO5INc/8y1uCbX
0xOPpHmL51s/NEKpURzTkbgvp8DoSG8YTeFdu+6eOnkfayO7klq7xGKxuBluBxKr
gpinpmEg88nn7j+uGq4imfQUoILc1u07axE80Llw5AaKAM39dfY=
=lAOy
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
