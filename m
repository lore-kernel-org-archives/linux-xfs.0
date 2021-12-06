Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCD1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 16:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346961AbhLFQSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 11:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380401AbhLFQRZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 11:17:25 -0500
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64DDC07E5F7
        for <linux-xfs@vger.kernel.org>; Mon,  6 Dec 2021 08:08:23 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:37838)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1muGXM-0000Gd-9g; Mon, 06 Dec 2021 16:08:20 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1muGXL-0001Rr-4f; Mon, 06 Dec 2021 16:08:19 +0000
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
Subject: xfsprogs_5.14.1-1_source.changes ACCEPTED into unstable
Message-Id: <E1muGXL-0001Rr-4f@fasolo.debian.org>
Date:   Mon, 06 Dec 2021 16:08:19 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 02 Dec 2021 15:26:38 -0500
Source: xfsprogs
Architecture: source
Version: 5.14.1-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (5.14.1-1) unstable; urgency=medium
 .
   * New upstream release
Checksums-Sha1:
 0ecbbb7b0092169064163140585e07bc00bf1417 2017 xfsprogs_5.14.1-1.dsc
 7badd55da219e01606c47fe6277303ce41663333 1308968 xfsprogs_5.14.1.orig.tar.xz
 ed28e221d5d91c5fb9d2ad2e197cb8f037f6ba2e 14212 xfsprogs_5.14.1-1.debian.tar.xz
 ba65b0542bb04ebb35590dea65dce140a71b3196 6389 xfsprogs_5.14.1-1_source.buildinfo
Checksums-Sha256:
 72dfb99f0f6ff9fa2add17f1839aa4d42caa94c3715bb766cbe2eb5ea9375cd3 2017 xfsprogs_5.14.1-1.dsc
 b03265654d99029d749937799a216133fc6b8ddfc51fed9db0e8349ac706fe63 1308968 xfsprogs_5.14.1.orig.tar.xz
 79a6a9c09e734118195aca1b2fc4f53fafa2e517404e43effbeec2e1bd442b29 14212 xfsprogs_5.14.1-1.debian.tar.xz
 94d1a3abdff51246f80a6c1b7e8324dc6bfe26bfd0e12f3f73b84bbff6d4a8e1 6389 xfsprogs_5.14.1-1_source.buildinfo
Files:
 ca6a33a3b04f3d39a2c09f409fbb539f 2017 admin optional xfsprogs_5.14.1-1.dsc
 e294efdf72a1871fa91eb02a500c555a 1308968 admin optional xfsprogs_5.14.1.orig.tar.xz
 699840a921c4ec94abb1f57676d1ec7d 14212 admin optional xfsprogs_5.14.1-1.debian.tar.xz
 5105d104fa5872bc4ce3470a22265b17 6389 admin optional xfsprogs_5.14.1-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGuL8kACgkQH1x6i0VW
QxQSSwv/R7EZa3+II7/iSRHep+hyRjc5Zg3ES34xefAPW00pt0jj4Hy8IEFXvfOg
sW0sAtIl0xKj+PtFRbFnELPDz73KKlN86cdjAf7N3BQz+6VhFMyDzpk8yJs9tJXf
/KpgJCAl7zuh8hvbwxL4MdYHEf0FdJOEKIiPYiGoV/WvngWuRFqVDxttTM4CYtec
Xh6xUsTah1VbjXf9g1nzoU+a99KR0DRAIZzBDQu5al3sSVP0I3or+um6f/OWjD5B
DxWo/IcBlLn++5cf1mWnnbVB5uZG2D5ObKLM2aD0EBDabPfHz4jpNCNlc/rc7tnK
dQdw91ZP5UqnBCFdqhhlsLHYPs1kLjkl9i8oGVy4+F538c3805+ciETT8WSg4uBl
PcKZ2rAwb/AUiSoyspaVwZyjv57Ma2m0W+p49HPYv5gQZElZGSN/EhKVJS9FKmuT
fmBpKE5COAvAArr9ItQLrrZEd/wHEoxnY3TUrme0LMOPQrQNFeqUGYE5t/ltpMuF
VOf/DivC
=JzBH
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
