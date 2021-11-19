Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981F7C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 19:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8230D61AD0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 19:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhKSTRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 14:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhKSTR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 14:17:29 -0500
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBA4C061574
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 11:14:27 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:35534)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mo9L6-0002yT-6S; Fri, 19 Nov 2021 19:14:24 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mo9L5-0001vG-1R; Fri, 19 Nov 2021 19:14:23 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     Nathan Scott <nathans@debian.org>, <bage@linutronix.de>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.14.0-release-1_source.changes ACCEPTED into unstable
Message-Id: <E1mo9L5-0001vG-1R@fasolo.debian.org>
Date:   Fri, 19 Nov 2021 19:14:23 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 19 Nov 2021 10:51:02 -0500
Source: xfsprogs
Architecture: source
Version: 5.14.0-release-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (5.14.0-release-1) unstable; urgency=medium
 .
   * New upstream release
Checksums-Sha1:
 9fe861e7667d8264db060a68b096a475443caffb 2073 xfsprogs_5.14.0-release-1.dsc
 1a8276f2902044bd1be3318c476141ec3fb9b423 1307332 xfsprogs_5.14.0-release.orig.tar.xz
 4842466df6c9a73017dd50d7daa68a9e94ea063a 14248 xfsprogs_5.14.0-release-1.debian.tar.xz
 333eb2e3bb400a1971b0bc6180a8af7ffa6fad67 6421 xfsprogs_5.14.0-release-1_source.buildinfo
Checksums-Sha256:
 f2990a3fd3d1a90d1f067a7cbed2c9608518f4a74e2206cfb60f566c481ad393 2073 xfsprogs_5.14.0-release-1.dsc
 903cb127a325be141e2f818894ae24230c67b16a525849539271ee037f873b44 1307332 xfsprogs_5.14.0-release.orig.tar.xz
 c49c2e2ac150bf774bfff8fec8ddf536ac319b8370b66c08fc4f28ce4cdbfc11 14248 xfsprogs_5.14.0-release-1.debian.tar.xz
 5c8567e27d70ba255f1e461b6fbcfca24e7f64a61776f749ac2d690f70d16ee4 6421 xfsprogs_5.14.0-release-1_source.buildinfo
Files:
 ebf987db8134cd1cf2e7d5c78366ba1d 2073 admin optional xfsprogs_5.14.0-release-1.dsc
 2ce433e563622cb0037a77da3b2d4c3b 1307332 admin optional xfsprogs_5.14.0-release.orig.tar.xz
 c4d6853a8c72f735ffaee0cf18384faf 14248 admin optional xfsprogs_5.14.0-release-1.debian.tar.xz
 2d83b3a8d05b16c144d649f5333992de 6421 admin optional xfsprogs_5.14.0-release-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGX7ocACgkQH1x6i0VW
QxQ4swv9HEP3VYj/5y5p3S7Dy/LfFQfJx+yl9sNzTxXvJK3fcxzvxrfUJrXOXzb4
ZlZrKfOdu4nksR4+oAh7nioLoMqzS+0BRQdzFh8zMmgghZPItzZ5Px+nhch8lrPo
JhqZjahGBabPEbvz2yFZNH4Sip0PfeDGv8x3/2hYUbO5UQ/u3cIODsyUU5zmp1TN
uMsS2UnRdccYfQf0mqnElMkLfCosJdTJClPFKXAKgLRJkZ75LoC7RzrXF3D8Afrv
AL2hvm5X7NUNBZy46qTjNL0sZ2GAClJ46gUU8h5AZK7WMMnyaQwoKh2BRGtTMt19
/YgF1vf5fNEd0Y9lMR9ibVbffBloC1jODqmJ6Q8qDQ+Cd/kPLI/tS/qrmYLyUuOP
J6VycH8gpIjtApWUAhicdTzS4UsgNBtj6nTPVv64Fx6/9k4/S8+i7ie2QHWAfHpg
MzpfZ5SruW6VjhqDQJ8tp4H5J908OLxd6W0Q2J8+fG8YVOLh+4BWzRIvUqcqBTiA
fwK0KIHp
=JxKF
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
