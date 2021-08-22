Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4FBC4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 20:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFC56127B
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 20:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhHVUjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 16:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhHVUjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Aug 2021 16:39:02 -0400
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E6CC061575
        for <linux-xfs@vger.kernel.org>; Sun, 22 Aug 2021 13:38:20 -0700 (PDT)
Received: from fasolo.debian.org ([138.16.160.17]:36470)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mHuEP-0001nq-1Q; Sun, 22 Aug 2021 20:38:13 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mHuEN-0005cU-Ra; Sun, 22 Aug 2021 20:38:11 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bastian.germann@linutronix.de>, Nathan Scott <nathans@debian.org>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.13.0-1_source.changes ACCEPTED into unstable
Message-Id: <E1mHuEN-0005cU-Ra@fasolo.debian.org>
Date:   Sun, 22 Aug 2021 20:38:11 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 20 Aug 2021 12:03:31 -0400
Source: xfsprogs
Architecture: source
Version: 5.13.0-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (5.13.0-1) unstable; urgency=medium
 .
   * New upstream release
Checksums-Sha1:
 da9ea080a1aae4e1bdad9037242d00bdad27c773 2015 xfsprogs_5.13.0-1.dsc
 86664522878991f8a36b0192c2594f78fc0918ec 1301112 xfsprogs_5.13.0.orig.tar.xz
 acdae7d4a678aa75b1e76fa4eb086c02ab848e18 13980 xfsprogs_5.13.0-1.debian.tar.xz
 2d2a13612ce55f5047c4e25c8efb3e0a037c280f 6113 xfsprogs_5.13.0-1_source.buildinfo
Checksums-Sha256:
 90ea1e78bebb8ab01bce9f3b17d047ffbd3ff33a5b4bb4d7fb5dad935a2f2565 2015 xfsprogs_5.13.0-1.dsc
 4e142d4babe086adf9016d8c606c805829da08e46389a4433f40346204f90cdb 1301112 xfsprogs_5.13.0.orig.tar.xz
 ec6c4761929639b19fb62808d74914e4f516a57ffd9836d3f2541787b9960bdc 13980 xfsprogs_5.13.0-1.debian.tar.xz
 b5c0a98b619c2fbd640082e76243906a38c6cfdbc93ea84db70bc8e246101ae7 6113 xfsprogs_5.13.0-1_source.buildinfo
Files:
 b0c787d820fca8b9c78630dc12e1bec8 2015 admin optional xfsprogs_5.13.0-1.dsc
 86777a5762f2e524bb9acfdead5a9045 1301112 admin optional xfsprogs_5.13.0.orig.tar.xz
 854e3bfd89d70f40460d82946012d936 13980 admin optional xfsprogs_5.13.0-1.debian.tar.xz
 bc940e71daa8bd48b02864ad96ed0804 6113 admin optional xfsprogs_5.13.0-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmEiqDYACgkQH1x6i0VW
QxRVmAwAhoBZZTo2bE7fuoH7bo3zSqgNWV1ztTxssLX2tf1csJVnJFICQP+Li13w
WXTTpt577Ep9MfXin0o8iWLU0OfLHOkyg2kMn5HtRQ9FW2jOFgSlxqCM0Z+vcNhL
tbw2Lmivg5S+/y35SvfCX+rfTlJj3xKunOAaewPlICfOhWxoCdLII67YpFkoV2jX
bvw+CqVzPDfnZ/CXLLT5Q87lknwisMWNKBJiU1O59KRpfzBbad8XtfPKBBR4uUCi
C1Xc+JkgPAQtS7/pQSD8qTfEddEUiCGoLVyHIjEa3gkz+YbqDxXT8xSXg9ApzGEl
8M3y1RsHOix1ISFQTes0buePtX3GqfavPP17TyfB1e0gp3tOypyvh4g6afWY/cyI
SY5VqH5e05RCHh/B21xQamU722DmWtdJe1x0bBrXdpEQJZuulx2pId4pq7EDZ5ZZ
322t5qItpB7r0zL/zESUY/Su13wf3hhnwkYVo15RAJBZezxqv55gSkoE0jUcXkRH
hPxA/f5V
=AQDz
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
