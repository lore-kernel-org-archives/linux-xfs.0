Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDF0C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 19:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67E392067B
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 19:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbhAYTKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 14:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731411AbhAYTJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 14:09:54 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB224C061573
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 11:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=JxMlfthIcRQ0Whz9DCuG2jO17FIaPDTpTGHokGNo36Y=; b=u34QsOElUZAbqUXbKz1kJk/kIu
        Q/9Mjc03wKF/hXZpelROVTCBJ/cSVc/claGkcQ2yccJ1b5RzYcWsxD+OjD1Hulr+gQWe0S65NOTDS
        T/4sM0Yk85PHe3vO9XnGbt7tbnIPHJcMSdY7H53+PeNUnMThK3F0f8aXynrE4z2ZyAWKxNYvMupyL
        21ChK1dgp4xLOTPHr1j8hSPj1RTHxjQC/BJXuxd21xiCdvmKuGq+xwt1fZoq+0iHuQ5n2Mfc+GB8E
        jvOkrRquwJyvhj1w/xuoBoynJvteoX1og/nEU95+rG84pNxXPz6k/YhgkXP30iDF4cTM96s7MH5+D
        BznItWxA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l47Ed-00065u-By; Mon, 25 Jan 2021 19:09:11 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: 905052
Message-ID: <handler.s.C.161160165121774.transcript@bugs.debian.org>
References: <662f1830-3e83-c7d6-b3f4-4688e42a2b23@fishpost.de>
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Mon, 25 Jan 2021 19:09:11 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 905052 buster
Bug #905052 [xfslibs-dev] xfslibs-dev: broken symlink: /lib/libhandle.a -> =
/usr/lib/libhandle.a
Added tag(s) buster.
> fixed 905052 5.6.0-1
Bug #905052 [xfslibs-dev] xfslibs-dev: broken symlink: /lib/libhandle.a -> =
/usr/lib/libhandle.a
Marked as fixed in versions xfsprogs/5.6.0-1.
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
905052: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D905052
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
