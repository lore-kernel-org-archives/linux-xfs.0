Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871E6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 17:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D33E64F6B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 17:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbhBDRWb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 12:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238445AbhBDRWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 12:22:17 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19E2C0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 09:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=5ih7yZDNTzdql6/A2dYTCfQH6oRnTKh5eTjP3c3KIEU=; b=i6Keug6AkR2PpMuGkHd/NRK3cS
        qTDh+JlFFTQIFdaGGANbULFgRvp8qA0awVMnDOiFZqFG6u95zX5W77zDEEqeof69vHDqDKg3uQVyx
        uGvu5yTIeIhxtJbMBc5KlFeSILlzbQRl5jEmFZXucG8rnJb6siRqDLfn7d5QVYiGJh4QsBp+h+BA0
        KBuvHJHtKawSBg+byZIdak+dLv6SiltG4pEnlSa6FIE3mUrRKN1Ef7CzDGlL61c4Ee+y/TbkJ6qV8
        o8YHnFv5a1yMwUAE2TXmbdC0m/4oOHdj76Kz1ryeNaTQGOvsPhEAca9KTlw0PjlGl6OE7RVjbDjVW
        N5iDTxGA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7iJV-0005Y0-IM; Thu, 04 Feb 2021 17:21:05 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     mmyangfl@gmail.com, linux-xfs@vger.kernel.org
Subject: Processed: libinih: Please provide libinih1-udeb
Message-ID: <handler.s.B.161245905619519.transcript@bugs.debian.org>
References: <a1fc03a4-7e01-04f4-d7c0-7f0ad8a182f8@fishpost.de>
 <a1fc03a4-7e01-04f4-d7c0-7f0ad8a182f8@fishpost.de>
X-Debian-PR-Package: src:libinih src:xfsprogs
X-Debian-PR-Source: libinih xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 04 Feb 2021 17:21:05 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing control commands:

> block 981662 by -1
Bug #981662 [src:xfsprogs] xfsprogs-udeb depends on libinih1, not libinih1-=
udeb
981662 was not blocked by any bugs.
981662 was not blocking any bugs.
Added blocking bug(s) of 981662: 981864

--=20
981662: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981662
981864: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981864
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
