Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7436C432BE
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Aug 2021 10:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7B060C41
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Aug 2021 10:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhH1KhT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 Aug 2021 06:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhH1KhS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Aug 2021 06:37:18 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Aug 2021 03:36:28 PDT
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC246C061756
        for <linux-xfs@vger.kernel.org>; Sat, 28 Aug 2021 03:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=6Hcc6/VsVxF8a36M7IPPBgoNdZOVe7pUdxdBVBsYg1A=; b=DoZV/2BnVOziXUhlw2KERgDCoC
        Og9ACv1ecLTDX1JMpMInXSwwDhsenyPhkbc7ZJmhay56StUgh8YgnVuYQsEOZbOGj7l1HlxQihYVG
        ncA8lAPRHcLMF37ynPVXsloiLXLWPAV4Nk22d6IImYhPARPFl0MLkbsapqL1uEv2Wfy8Ams8gSu/p
        uTub3hJau5qkU/jTh/3Fc9kThXxgO4acd8Tb6Nmi6J4jQIwVgiZGcvBKNsKlgHAElqKkQqJvLa1aJ
        aezyEA2VD0EayXiWXfGVTfwl4iZmO/SpPFvtYyO0ZNl+5ltMwrkU7xyAiJ6FmaGK2Clem+QI5cXhx
        VdKsbx9w==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mJvMe-0006w3-BF; Sat, 28 Aug 2021 10:15:04 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: 981662 severity
Message-ID: <handler.s.C.163014558624663.transcript@bugs.debian.org>
References: <adbff455-e70a-6354-dc08-db3c2765ce7d@fishpost.de>
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Sat, 28 Aug 2021 10:15:04 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> severity 981662 important
Bug #981662 {Done: Bastian Germann <bastiangermann@fishpost.de>} [src:xfspr=
ogs] xfsprogs-udeb depends on libinih1, not libinih1-udeb
Severity set to 'important' from 'serious'
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
981662: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981662
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
