Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5480AC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2780A229C4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbhAYXqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732395AbhAYVSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 16:18:49 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFB1C061573
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 13:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=0ziUlydmgO067K67B0n+P2M3zyZIbPLD9gUuwPvwlWs=; b=pgcw1Ex72JgvyXO32T8miWE51T
        M1zoFJtuwnykN0JM1DsQQKa3N/VWj0q2C8KPBAo1zVnF9BN8M+PCRuo8YqgtzcqCCS+2hXHVP7gc3
        T0X3lXscXu80N5AQQ9lBB1gC0EqE0Aw4ptVOYKgFbzipIaLd5I5tWiwdvnpkUoC9vFqWu04ARht3Q
        4h21j/SRR25gJlx2Nqo8elYy8JDBhHl8wLZaelHVBu4CS+79yEWiY+u5G2DryQulnfcV0630J1DXT
        N09mwKWW/dO8MI9xUSz4B2wouSbKepG6G62NNUwMXp3pQtIGPqNIVi+GxrnvcHonEbQDShVtZnNL9
        kh8A0thA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l49FP-0005j0-OK; Mon, 25 Jan 2021 21:18:07 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: Correct dists in tags
Message-ID: <handler.s.C.161160938021640.transcript@bugs.debian.org>
References: <3064077e-4323-f4bb-4e9a-0c14ec05c6a2@fishpost.de>
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Mon, 25 Jan 2021 21:18:07 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 890716 - bullseye buster sid
Bug #890716 [src:xfsprogs] xfsprogs: FTBFS with glibc 2.27: error: conflict=
ing types for 'copy_file_range'
Removed tag(s) bullseye, buster, and sid.
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
890716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D890716
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
