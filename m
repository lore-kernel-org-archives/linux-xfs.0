Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C945DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 19:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B408161283
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 19:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbhKSTpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 14:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKSTpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 14:45:12 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C96CC061574
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 11:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=Lr+K0/Fdvj+1JspBFPkmJE4zPCF5iw1XZrWhlEBhPIE=; b=GD50zOLtBIQllnS5WLBYSQxiww
        GuAd6tesq1e0z91f/gTtT5hYeTucFXi/NPy9CfN6HZoIiOkeDPnmvxYJA8mKvLuFuFI+x41RVUuMt
        dSHhk+kCMHmX06gTuH9RCQ67si2JlNdA9LV7OmCCq5qHXXXTDfvT7hltjSF1+kfgl62dfmi5R/zl6
        jxM79uBq3nrF0QBFgDXwvgs7bLzVM2s49ee+0av01Q/4yWaSOQI5jXuqhpkeHZ7GpO2PN1sYsFRPG
        yi3rGwFxceasHXgt7ftoGMV9EIp14rcYpHp0r7ByMndNZT2L81x9yo1q9hwB0SFkrYNudXWKATdxI
        JaaIomAw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mo9lt-0005N0-1d; Fri, 19 Nov 2021 19:42:05 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Adrian Bunk <bunk@debian.org>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: fixed 999743 in 5.14.0-release-1
Message-ID: <handler.s.C.163735085120487.transcript@bugs.debian.org>
References: <1637350840-849-bts-bunk@debian.org>
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Fri, 19 Nov 2021 19:42:05 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> fixed 999743 5.14.0-release-1
Bug #999743 {Done: Bastian Germann <bage@debian.org>} [src:xfsprogs] xfspro=
gs FTBFS: .gitcensus: No such file or directory
The source 'xfsprogs' and version '5.14.0-release-1' do not appear to match=
 any binary packages
Marked as fixed in versions xfsprogs/5.14.0-release-1.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
999743: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D999743
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
