Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849B7C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4200464D73
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBPMth (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBPMtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 07:49:36 -0500
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D29C061574
        for <linux-xfs@vger.kernel.org>; Tue, 16 Feb 2021 04:48:54 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:46416)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1lBzmd-0005Ot-49; Tue, 16 Feb 2021 12:48:51 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1lBzmc-000A5L-28; Tue, 16 Feb 2021 12:48:50 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.10.0-4_source.changes ACCEPTED into unstable
Message-Id: <E1lBzmc-000A5L-28@fasolo.debian.org>
Date:   Tue, 16 Feb 2021 12:48:50 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Tue, 16 Feb 2021 13:31:30 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-4
Distribution: unstable
Urgency: high
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 981662
Changes:
 xfsprogs (5.10.0-4) unstable; urgency=high
 .
   * Source-only reupload (Closes: #981662)
Checksums-Sha1:
 bdad02aac22258f7d03aaafc7de910309e861d62 2047 xfsprogs_5.10.0-4.dsc
 37b74a2bceb4d6eba1b2c7f3cfcb33a62bd31f41 13924 xfsprogs_5.10.0-4.debian.tar.xz
 32d0b8d03beaf56a1e74fca13f31466cf3fc6ec9 6545 xfsprogs_5.10.0-4_source.buildinfo
Checksums-Sha256:
 839e28e8d8fcb932013f50a371cf8a4ba29016a36238e4880c2a593b81ce9211 2047 xfsprogs_5.10.0-4.dsc
 616a7730b773c60e0877694e419374174027a8cb540029509093a40da178bdbc 13924 xfsprogs_5.10.0-4.debian.tar.xz
 c3a87d3e6d1b60eff9bb9989c471239fc7bbc373f02b525bf553cac8ad52dd09 6545 xfsprogs_5.10.0-4_source.buildinfo
Files:
 62e8be79f08484553689fcbd3153e015 2047 admin optional xfsprogs_5.10.0-4.dsc
 7fd577f89a73a18a91630b02cb42bc25 13924 admin optional xfsprogs_5.10.0-4.debian.tar.xz
 1d0b1ab28fa60d8ca7c44d68462a60f9 6545 admin optional xfsprogs_5.10.0-4_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAru/AbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMU2DMMAK4reAI4MtsyfII66TMQ
M5f91mFFkbWLB5AMLuYlf+gP58x7WHcxCRzby6IagBTSRxPHx5s8mNNiy4P1NSfE
QXufjFQ50/iJEafVm+wBJBoqvVZkupoNuqEo1LgYciI/s0YqWDQ/s94ybdwnE6Fd
eabskKy+ag54KBXzBbZUY5u5OpZ4UMqPI1uniFnBQ/4rmlQetXn+RYalMoir5u+8
QEVbxheLUy7virdVgvM676sbdJxvoTR2DFF/VfrReG3kfAyz08KS7B9fzxgrn9lr
QBrLtsZU9Deo8ueXZr3pSqpUG+kDMGrJKAAog6Ptgue+2FxPttoxc0pA79DDwaxR
K4TsInZUNwIy2M4UOuN+/R7gmChjzUcW/ecn0IxSxzDQkWiL5DK7fgV8TUBoBjml
g4Em8kU1F2x3ZjCePp0hTS5PlQ2Ra9DcvNHZNifTV21L/ffFzKpHFkC/pa/E6P7v
n5oERP2pwkG2jiZOkJqVFKjfpY/+569SpYVuCXBjZRfEvg==
=j5hW
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.
