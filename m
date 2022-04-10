Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD33C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 14:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiDJOlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239985AbiDJOlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 10:41:32 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F028F643E
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 07:39:17 -0700 (PDT)
Received: from [192.91.235.231] (port=46930 helo=fasolo.debian.org)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1ndYif-0003ax-Vk; Sun, 10 Apr 2022 14:39:13 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1ndYie-0006os-QN; Sun, 10 Apr 2022 14:39:12 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bage@debian.org>, Nathan Scott <nathans@debian.org>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.15.0-1_source.changes ACCEPTED into unstable
Message-Id: <E1ndYie-0006os-QN@fasolo.debian.org>
Date:   Sun, 10 Apr 2022 14:39:12 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Wed, 06 Apr 2022 16:31:00 -0400
Source: xfsprogs
Architecture: source
Version: 5.15.0-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Changes:
 xfsprogs (5.15.0-1) unstable; urgency=medium
 .
   * New upstream release
Checksums-Sha1:
 a643abc9eb6a3d420ea8323dbc29e0c48d73557d 2041 xfsprogs_5.15.0-1.dsc
 10c6afc347f51758a6960b92e5c22831b5165ff1 1303080 xfsprogs_5.15.0.orig.tar.xz
 07c8cdff58ca03cea35b4a720e7ff91d12ae2f3a 14332 xfsprogs_5.15.0-1.debian.tar.xz
 95e43f6ffad68f7ca124fffebe86a124713c1e9d 6321 xfsprogs_5.15.0-1_source.buildinfo
Checksums-Sha256:
 e2e5a1d93b2ea0f41889fd6191ede687c9acf376eb4eae7e69f0d7f48044c11a 2041 xfsprogs_5.15.0-1.dsc
 13d2bf3830eba0027ab558825439dd521f61c7266783d7917213432872e74d56 1303080 xfsprogs_5.15.0.orig.tar.xz
 cd402b0205d725f1d1bc6f73db012f40882c7ff7c372e0afec57a79087d2dfa8 14332 xfsprogs_5.15.0-1.debian.tar.xz
 a454e3743908f98abb4614b91fc39a00d42fca37d1dd563450cd30e0411c5a46 6321 xfsprogs_5.15.0-1_source.buildinfo
Files:
 ee9b22adb60a0005e759389a688a5049 2041 admin optional xfsprogs_5.15.0-1.dsc
 97f20905608e180ad73c2453b96333c3 1303080 admin optional xfsprogs_5.15.0.orig.tar.xz
 217a3e3fae8142854ac2644dfdf9b2c6 14332 admin optional xfsprogs_5.15.0-1.debian.tar.xz
 af94b790f3c1bb36b1911a04d6d7d8b5 6321 admin optional xfsprogs_5.15.0-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmJS6V4QHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFBlPDACCF/SmrveLIirvbgKUUIbfTwhw53SLAeuY
J01IUP8ROQXapJvwnMjkoStLr4FL1CFpgnCujFgD6H/pHpAnAiDts2f3DIDqHBWX
8b4Cq7Ef9mEMZQJy0J1r4EaigT+gtsF5Cy4ROVIyUwaH5Eynbo2es7lQx6kQ3yv2
Ssp+sQEQUafROlbRI4y3vELo4sIHzz2N+OhCERV/IwgT0DL7bxanmyYuhmt+8Zlr
l3u2pET24yNC6qy5g8lvNOqPCHYNjsO6ZG0CfN/lxDF2aB0IDf2RKTX9t4frQ+8I
aGs/ZqJ57KNr9t5RMSHe2/Shu98uHMIDG70KBdIQPaVxWACiqx6To6Q48+ey0gb7
w3yeYsQ6O2NMQk9Aqb1GTrG0XySi54cvSUal2IidzwOA4sTBU9edeONvoqzEt7i1
j3pmoMP8heErpybPEvsDhzP6LPkvUwxi6kbp3zF+y2c8iv/kgRo8PJH5LBo/yhcA
q/nBY1ewgiEZOLYKq5eTfewHNKnkpqY=
=8XAD
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
