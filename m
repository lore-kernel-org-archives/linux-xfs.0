Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B9FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6441022E01
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbhASWYu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbhASWYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 17:24:47 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65928C0613C1
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 14:24:07 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:37376)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1l1zPy-00071M-7W; Tue, 19 Jan 2021 22:24:06 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1l1zPx-0005hM-B4; Tue, 19 Jan 2021 22:24:05 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        Bastian Germann <bastiangermann@fishpost.de>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.10.0-2_source.changes ACCEPTED into unstable
Message-Id: <E1l1zPx-0005hM-B4@fasolo.debian.org>
Date:   Tue, 19 Jan 2021 22:24:05 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 14 Jan 2021 18:59:14 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-2
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 979644 979653
Changes:
 xfsprogs (5.10.0-2) unstable; urgency=low
 .
   * Team upload
   * debian: cryptographically verify upstream tarball (Closes: #979644)
   * debian: remove dependency on essential util-linux
   * debian: remove "Priority: extra"
   * debian: use Package-Type over its predecessor
   * debian: add missing copyright info (Closes: #979653)
Checksums-Sha1:
 9c7923ea5735242a29b8481cbd38059c850433b9 2034 xfsprogs_5.10.0-2.dsc
 9e5cbf9b3a561c3b9b391f0b1330bcb4b3537d38 1273332 xfsprogs_5.10.0.orig.tar.xz
 7240aa6c2fb907b9f1aeec8ae6d19fb8c62c1585 13792 xfsprogs_5.10.0-2.debian.tar.xz
 87001ed58e1229bb8b9c7cc4348b5e07646675ef 6593 xfsprogs_5.10.0-2_source.buildinfo
Checksums-Sha256:
 d4b995161ecfc754895c3a91931db9787fffc924fbc2a5cd51abb11a28ac1522 2034 xfsprogs_5.10.0-2.dsc
 e04017e46d43e4d54b9a560fd7cea922520f8f6ef882404969d20cd4e5c790e9 1273332 xfsprogs_5.10.0.orig.tar.xz
 3f144a529ec274ffd720ad70c347b294c9a787868b2119ecacbf0c16bcb642f1 13792 xfsprogs_5.10.0-2.debian.tar.xz
 a022f266d04946b600fdb12815a4197d4dbb70ae8bfe92e5c682803bba9ac42d 6593 xfsprogs_5.10.0-2_source.buildinfo
Files:
 49fad22f902144635cd5a7c06de1fb1e 2034 admin optional xfsprogs_5.10.0-2.dsc
 f4156af67a0e247833be88efaa2869f9 1273332 admin optional xfsprogs_5.10.0.orig.tar.xz
 6bb054391ad11b6d23d883a907e099be 13792 admin optional xfsprogs_5.10.0-2.debian.tar.xz
 853ed7390e20376455676cf65ba4137d 6593 admin optional xfsprogs_5.10.0-2_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAHV+cbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMUZCIL+wXFyjxnBr2VGlTj+BVU
taQwxuvEZoFwxvNwZ4Z5s38FBi6DzPWLF2jxCv4M0UTOpDPstg5WXebhfOnOdp4D
0WW8G39jMIB2J+b0OQEGcMKdwuXKYKfDdBdOa+lesUoUU8AZEazS/whzMa7FD7wB
/av/28PvYdWFK/ddERfujPIa6BtoIE2QszggOCHqCbUt3egQLCTxA+2qPR+f5Nrs
VT/xgDrkkHC9ypkU8kypv4XhetHKwwxDyp+4PLja0OSnuH6/KzmiV8gI/Hq4Y4/l
lYzXiWWjz5ofEHc3haGxqsKxabyRT6h31INdxfKjFhnFVrEyh3l+KjJL4AXcn8wH
fB/DL2uquJkWBJ+N7xD/UYvDylwNaqnkyYOMCy+JyKE1lJZv5AfAGlsZ3VAnOeGT
Rn8e7XF+4lPWsckPZ+YZWqGDmLbRxAeg5xGQ2iFKFPfwq0grKjARF+33JWkHR3Jk
O/MWldWzIuogu77fsZbPlRPgG7dj8eA2pjscQJOXo/yb6g==
=IDLF
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
