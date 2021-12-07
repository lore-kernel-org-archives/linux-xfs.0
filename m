Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04147C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 12:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhLGMy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLGMy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 07:54:27 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2761DC061574
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 04:50:57 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:57012)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1muZvr-00063M-5N; Tue, 07 Dec 2021 12:50:55 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1muZvp-000DCk-UF; Tue, 07 Dec 2021 12:50:53 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     XFS Development Team <linux-xfs@vger.kernel.org>,
        <bage@linutronix.de>, Nathan Scott <nathans@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.14.2-1_source.changes ACCEPTED into unstable
Message-Id: <E1muZvp-000DCk-UF@fasolo.debian.org>
Date:   Tue, 07 Dec 2021 12:50:53 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 06 Dec 2021 14:26:57 -0500
Source: xfsprogs
Architecture: source
Version: 5.14.2-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Closes: 1000974
Changes:
 xfsprogs (5.14.2-1) unstable; urgency=medium
 .
   * New upstream release
     - Move rogue fallthrough macro out of linux.h (Closes: #1000974)
Checksums-Sha1:
 7d58d8887618f090bfc2b5c0d9c309da788ba960 2017 xfsprogs_5.14.2-1.dsc
 035e552cf4a08d5dbe1330ec1e3e6ceeb21b6bc9 1308912 xfsprogs_5.14.2.orig.tar.xz
 ef951cda194275eee5c3975cfd46544cf0f70a67 14316 xfsprogs_5.14.2-1.debian.tar.xz
 2d71d75e23c654180f1c794e4d5c8c569f62873f 6141 xfsprogs_5.14.2-1_source.buildinfo
Checksums-Sha256:
 6fcd3408e1c1edc0d776f54323424dd36eeaffc148191911c464d5a02b2bad6b 2017 xfsprogs_5.14.2-1.dsc
 01ccd3ef9df2837753a5d876b8da84ea957d13d7a461b8c46e8afa4eb09aabc8 1308912 xfsprogs_5.14.2.orig.tar.xz
 9581848bd59128cdd38ccaa4c92d82d5ddd66c74baa9dc2fc76fb5146497af4a 14316 xfsprogs_5.14.2-1.debian.tar.xz
 4d20924cfc79905a769dbff0aca10eab696536aab5f591e36e9e35001f63a5f6 6141 xfsprogs_5.14.2-1_source.buildinfo
Files:
 14d5f362b8d4ea4bee80edb78a36ad9e 2017 admin optional xfsprogs_5.14.2-1.dsc
 597e7067b8aa24d440bc87c29e987377 1308912 admin optional xfsprogs_5.14.2.orig.tar.xz
 89ea7c8a994352dcecd267a0ec13136c 14316 admin optional xfsprogs_5.14.2-1.debian.tar.xz
 4e41a97053eeb8ec0c6547e293683776 6141 admin optional xfsprogs_5.14.2-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGvU4sACgkQH1x6i0VW
QxS0egv9HwfcbxyRn43bj+CxNKMCdKtgIPfV0SZxejKwarbdDg3d8f4/1i7gNVpJ
+isPdnKvVULyxEhQxdoYfsjWaTCCX3YMlyrd6i5+2nrn6J9cwXrrJJdjPWvMgXR2
o2u+brvm9cPYllAbbEVUYe6dtHY+/cH1c16W1SYK3yln7MWWWCTvAT0a7YrnrZQj
7FVdd0qcbM+PU/m2qwpUxz2KmtVjJ8RfiF+a/X7P1zeAxAoODFx3GRRY9cTyvgnV
tDwAdlSu4W6UgiKwgTpDFUT6EPRigEEqjTk3k0BgvYeFEidX57TsknQXwWKn3dI/
Dxfo5wxGVlDIywj4iN9EugsYCBwW8ggm60St/BiJhuNpgup339yUBGtszm/x97RM
XLKTOgb642bqTVu1Otee+Bdd5VSMwlmkyUnDDvuh52EPF3uFNf55sgiYsv02ATrB
jb8rcN1zeqUZ9r+9m6w65pp2wQX6HAWqZSUEl2HToPITse3OPwwCPUKZja+BYpT5
bGdytpiC
=ORx6
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
