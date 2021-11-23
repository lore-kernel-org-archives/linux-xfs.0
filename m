Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B61C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 21:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbhKWVWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 16:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhKWVWJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 16:22:09 -0500
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF89C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 13:19:01 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:59048)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mpdBr-0002tH-KL; Tue, 23 Nov 2021 21:18:59 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mpdBq-0006s9-Eq; Tue, 23 Nov 2021 21:18:58 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bage@linutronix.de>,
        XFS Development Team <linux-xfs@vger.kernel.org>,
        Bastian Germann <bage@debian.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.14.0-release-2_source.changes ACCEPTED into unstable
Message-Id: <E1mpdBq-0006s9-Eq@fasolo.debian.org>
Date:   Tue, 23 Nov 2021 21:18:58 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 23 Nov 2021 21:31:02 +0100
Source: xfsprogs
Architecture: source
Version: 5.14.0-release-2
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bage@debian.org>
Changes:
 xfsprogs (5.14.0-release-2) unstable; urgency=medium
 .
   * Replace the Debian-only #999879 fix by upstream patch
   * Patch: libxfs: fix atomic64_t poorly for 32-bit architectures
Checksums-Sha1:
 4816accd926e15a9e72e99fa3d1061e9991b6d75 2073 xfsprogs_5.14.0-release-2.dsc
 a4f063bd1a0bd8a71b3d20aff00acb2962c8bcda 17416 xfsprogs_5.14.0-release-2.debian.tar.xz
 635bd8038e845addc15a0bbea0cd1124d216096f 6421 xfsprogs_5.14.0-release-2_source.buildinfo
Checksums-Sha256:
 3ff18cc6975c9d90edb0430a92956183eee55a702f95e408640c217631164582 2073 xfsprogs_5.14.0-release-2.dsc
 07b222b39e87ea218da03342f2a69cad50c7ff77fbd54d3aa37e7204fe6e6a7c 17416 xfsprogs_5.14.0-release-2.debian.tar.xz
 9b949cada04009a7c7d9db120aeb60d4b0599eba067b89fc97fbb8dfb54d8042 6421 xfsprogs_5.14.0-release-2_source.buildinfo
Files:
 2f7cb366abf69f99ea2721f8a278fbab 2073 admin optional xfsprogs_5.14.0-release-2.dsc
 d16cc94ef82ec47879a2cdb5410e2cd6 17416 admin optional xfsprogs_5.14.0-release-2.debian.tar.xz
 2f5c8d0be39aa835af77efddfa0ed53b 6421 admin optional xfsprogs_5.14.0-release-2_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGdVXgACgkQH1x6i0VW
QxSv+Av/arLmgp9FpT/39URQmojUbKfkcgnp2XDsqJAcnAbRGllBpPtndIUxz6O7
e8jpNGlLv5+2l3tW6tzgAhzzElY8M1wjwdpjtMzq33vO6cLe603onGXSfjBe2apK
zzOTVTDNAe+HfHRBs6mJSLB2I97jyfsr7yz8vfr3fBB9i23POA4z5ypgpkz2Ek8X
Bg9V1iHDHbuRxVk2cy4TRLaIb2ABYBnFATldB61hq6h6Z1X7jkrpfuwNctWmyEZN
T48H6Slgb1Y2y2VrSJYkRKKzxyRGTM1ZS6SO3waZ7XwMnDboCZWPms+Zg6kRJWaQ
rQRW6iAsH8cKsXdeHmPDhyTWwRtKNGFaNt5fyIk+wHcm2QmynrzqYXTtY/uLVSHy
OF/J0ZzTkWoQzgOlx2ugjLuNqAfPA3oC2Pi3Z2FS+IxM2A1C4pAHfQ8zAlD+g51e
KDefbQKVPyl6D7OszTG3lTpQN4Y72NJ7+GDXaBfq/3KSwHZ3Cnlf1T9f7WKMdrPg
SFGuaoDj
=SlW/
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
