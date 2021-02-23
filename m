Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BTC_ID,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD5EC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 17:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792CB64E83
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 17:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhBWRTi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 12:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbhBWRTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 12:19:38 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C3FC061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 09:18:57 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:48868)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1lEbKq-0001gu-Te; Tue, 23 Feb 2021 17:18:56 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1lEbKp-0009HX-Tw; Tue, 23 Feb 2021 17:18:55 +0000
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
Subject: xfsprogs_5.11.0-rc0-1_source.changes ACCEPTED into experimental
Message-Id: <E1lEbKp-0009HX-Tw@fasolo.debian.org>
Date:   Tue, 23 Feb 2021 17:18:55 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Sat, 20 Feb 2021 11:57:31 +0100
Source: xfsprogs
Architecture: source
Version: 5.11.0-rc0-1
Distribution: experimental
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Changes:
 xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
 .
   [ Steve Langasek ]
   * Regenerate config.guess using debhelper
 .
   [ Bastian Germann ]
   * Build-depend on libinih-dev with udeb package
Checksums-Sha1:
 98a46cbded9c0b74d8cbaa1010f512cdb3acf011 2083 xfsprogs_5.11.0-rc0-1.dsc
 d7fbefa12a6a6e00fba04298d9f024492465ee31 1880281 xfsprogs_5.11.0-rc0.orig.tar.gz
 31f7936ecce890ce76fc752140d3fe5a8487a7eb 13948 xfsprogs_5.11.0-rc0-1.debian.tar.xz
 3b89e3eb473ed82f23ad8998e327db3ba5009b2f 6617 xfsprogs_5.11.0-rc0-1_source.buildinfo
Checksums-Sha256:
 8fb3f45dbf53ee00ebcdada17199e8d554aec1289f3071dcf4b22691752663ab 2083 xfsprogs_5.11.0-rc0-1.dsc
 3724b205b65187085cdb2b1b72644812796727b225658e677bc50ba3f89aa92b 1880281 xfsprogs_5.11.0-rc0.orig.tar.gz
 240b5444f2468732dc284bbcd5a442fff0e9081057fd78d664d6ac1ff2e0dc3c 13948 xfsprogs_5.11.0-rc0-1.debian.tar.xz
 b42f66fe99ee85783de7783a172c96cbdafe3dbe9e6343c004dbe245b63358fe 6617 xfsprogs_5.11.0-rc0-1_source.buildinfo
Files:
 59d076122efb3bb7ef79c982d1825b5e 2083 admin optional xfsprogs_5.11.0-rc0-1.dsc
 590248ac1fdaf8c0e3eadfca866d473b 1880281 admin optional xfsprogs_5.11.0-rc0.orig.tar.gz
 8d860fc8014303b329cdba3955ce27f0 13948 admin optional xfsprogs_5.11.0-rc0-1.debian.tar.xz
 33165f4db465fff5ee9fb66bddd38122 6617 admin optional xfsprogs_5.11.0-rc0-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmA1NMAbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMUq+cL+gMySwvZPs3lEDYU6hCC
iHBTVujsv4xQDpCMgBbYHyPAjez0g1tEqFMuJkJO2SOk6C+5ZgUongX7wK4pdTu6
/MCXDlPtyKgs0X70AZsdUc+COuVhVTuHTNf3cPcf+Wqtp/BO6u8lj63ZHZh78aoF
cxgoL50z0tf5Y3Mcxqg7B1+dKHH2t1WhYdjsGdK7y+kBNDrevjLcj7LaynELKKN3
Yqk7lIhigKX2+E0CISGj7e9QBy5xa/hkqy7c+MG/sn+CphhbWb42a+11jCZbEVPv
xeAK7LojcrYpV8NWYfTP86H/DrwWSXZubsIYip41mkRQsb4JIVfCIBxBXzNh5BcP
694N4wfPp4bl1+C5nanxkv7dmQSjS0MzhoGVVFGmV34JPuefwg4L1c7nYREoZYSk
FxrgFhCLIduNSrOCybcS4Gi4rFR7QEdAeF4DKpMOXP0qhOLtu5UIE0qhgivfq0Ea
8QPv/+XbHorgV0meV5fmKFxwRvWIDPkKLhphB5BJCdWObg==
=IeMS
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
