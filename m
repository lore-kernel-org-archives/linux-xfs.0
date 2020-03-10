Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AB3C10F25
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 02:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF07424655
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 02:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCJCGC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Mar 2020 22:06:02 -0400
Received: from mailly.debian.org ([82.195.75.114]:53270 "EHLO
        mailly.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgCJCGC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Mar 2020 22:06:02 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2020 22:06:00 EDT
Received: from fasolo.debian.org ([138.16.160.17]:45572)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1jBU2J-0005Rj-1o; Tue, 10 Mar 2020 01:50:23 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.89)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1jBU2H-0009Kt-TZ; Tue, 10 Mar 2020 01:50:21 +0000
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
Subject: xfsprogs_5.4.0-1_amd64.changes ACCEPTED into unstable
Message-Id: <E1jBU2H-0009Kt-TZ@fasolo.debian.org>
Date:   Tue, 10 Mar 2020 01:50:21 +0000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 20 Dec 2019 15:43:02 -0600
Source: xfsprogs
Binary: xfslibs-dev xfsprogs xfsprogs-dbgsym xfsprogs-udeb
Architecture: source amd64
Version: 5.4.0-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Changes:
 xfsprogs (5.4.0-1) unstable; urgency=low
 .
   * New upstream release
Checksums-Sha1:
 2f413e4c86822f9ce83fb5078e025e43785dd1cb 2106 xfsprogs_5.4.0-1.dsc
 d3c9d707b4e7ac32dd2ad842b969a832eeb2a02b 1832044 xfsprogs_5.4.0.orig.tar.gz
 ebe266aeed22004dec764e5dd7593141877c28eb 9516 xfsprogs_5.4.0-1.debian.tar.xz
 0473d1783f9e7d7d748f5d4749d696a398aef77a 110064 xfslibs-dev_5.4.0-1_amd64.deb
 a808a4cb81109a28739a958be1bea7e8f48e5a3a 5250220 xfsprogs-dbgsym_5.4.0-1_amd64.deb
 c3963c715352178ee9b8564a9a184eaf3bb0b082 132872 xfsprogs-udeb_5.4.0-1_amd64.udeb
 7ba3a315275117414952fb123da71dc69a29ec26 7532 xfsprogs_5.4.0-1_amd64.buildinfo
 b537f9af5e26f0438e5d81293219179fcc33a09b 919880 xfsprogs_5.4.0-1_amd64.deb
Checksums-Sha256:
 1bdb7ab28539abe0d0967643da05e1ff6d9fc920d5e6624c75d6ca3140264f06 2106 xfsprogs_5.4.0-1.dsc
 dac6fe9b94183f7be00f801a404c1c12859912da3369b5c20b9f976f85d23178 1832044 xfsprogs_5.4.0.orig.tar.gz
 0fb5e100de1b15da09e824f6f157577af4fe66ca5dbbcb215647bbb23bcbd668 9516 xfsprogs_5.4.0-1.debian.tar.xz
 944bd6d6d7f20fdf54b358fd26113af2f2012d840554048110900e2872855557 110064 xfslibs-dev_5.4.0-1_amd64.deb
 64f83888a64a17a96877ad88a39da0013d2bc6f6f84049b1f8f4de1fc7c1cb21 5250220 xfsprogs-dbgsym_5.4.0-1_amd64.deb
 62eeb8410aaf6b670396c1aff1314c8ba47323bbbc1ffeee4f4c509bdf2a54d2 132872 xfsprogs-udeb_5.4.0-1_amd64.udeb
 48580f8cc6599b2a28cad8db30ae16d00da852cd5b1cfde64fce8c2c73c15f52 7532 xfsprogs_5.4.0-1_amd64.buildinfo
 619a3bdbbfc948509f7d374591b28e3595eaecb191589fbbe23b78062ceb7197 919880 xfsprogs_5.4.0-1_amd64.deb
Files:
 f6c7dc32327686e42ad0a090a058f8c0 2106 admin optional xfsprogs_5.4.0-1.dsc
 6d0302582dbc27a94f8dd19171cf877e 1832044 admin optional xfsprogs_5.4.0.orig.tar.gz
 b406f6d9a26139d738021f89a829abbe 9516 admin optional xfsprogs_5.4.0-1.debian.tar.xz
 48081a78bf72b79b598baa18ad564824 110064 libdevel extra xfslibs-dev_5.4.0-1_amd64.deb
 5e85c37f1789d7aa58538e53bd3bf4cb 5250220 debug optional xfsprogs-dbgsym_5.4.0-1_amd64.deb
 9f26f1b4747880e460d027c502285a29 132872 debian-installer optional xfsprogs-udeb_5.4.0-1_amd64.udeb
 9f7ebea06f459737da657203e0078c9b 7532 admin optional xfsprogs_5.4.0-1_amd64.buildinfo
 f8c18e8bc181c14f7590ce0fd51ee5d7 919880 admin optional xfsprogs_5.4.0-1_amd64.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE96vodh5v5oY45ig6/ghC7jbdjAwFAl5m7tMACgkQ/ghC7jbd
jAzw4hAAtyqGMCOchkEWscRSGS59W/CXNhraisD+Ysv/+y05EIsOAA+dwaKLYIte
pKCu6QqaVJzazzugsbGpz7HBukXdJxEAxmFmsqYrnl7oY8SCZ6zpG+HLBYQTntck
1RHQ7sHavWM4g+4Q9g+rzhgK+K+iCjcS5DNOkfFIgJVYV7DAyLvLavf/m9NDHwm+
r/TlyBd6L8BfHdLPRCmci7Q5o6IbIjn1CQipesrqZBB774LN+SkMo6Kncjs+nDXa
oiOcTewSOwPePYyUwUJY+EeOsne4c6R+LV/VnqFG7IW8HA0rEF+707CgxLP7Eepv
IG6ru30KA1rFnl6UnkQwY1xMGrmrosgz7ncQ7DxLlUH+1KmeDCvR8hczUCTONFXj
7ErWqr+6n3gCiUcRYRgTulAYd6vpLr8gNtQbOUtfU0MR6pkG5nm+SffYUQLdFp5R
ergkjfisg0GM18jKzJRkqm2HV5KBuMma4avVMnyRrJBSNzgiq8zNTvw+oNOAxa1+
C+cYx9Zv2FRKzOOz5n4iIbpPDmMGv7ih/1Ni+wgVP/lOAnIOffjoOEE3/jd+FWJu
D3UH1H6MJgZra2NTorn1Uqt9+JDj2+5yFMOwQHBm4gflYGjs7fG+nk+BUk0tl+pE
pYqKX9rMF//VOSreKUNpVN9l+WBdEWSEXUhCUsU2qFFgxO/qpaA=
=uhUp
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
