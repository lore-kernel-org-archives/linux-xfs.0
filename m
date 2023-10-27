Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A71C25B48
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 22:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjJ0WmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 18:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjJ0WmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 18:42:09 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DFEAF
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 15:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=jrAYowDZowrEolMQ43pyuFOhjupAb23jFNUNqJEZ47g=; b=twuCatvJ6vMTBTPQbmwogJepp6
        xnTICNIW+TNj8K5F+9/FVLPM2AFLvrfzItkxITvPY9pBIKg3mWXvEw/QtgCntWj/d32Bbi6ZKUoCs
        /QmckkU5HaglWo+f/oZxquCIlW6Cmevc586kvLEoa/x+ZKkoyrX1QV+OFG5uOnnvNVYAlIwLCUNfq
        lEwMbH/tkDS9r28JJLMMB9PmBJsFlJscdXaZVVKkizfynrkLK7vN2FmnOrLDOJD4nuU4i8UvI3oCE
        he+y9PyLCUtRuAI0GQR5FrqkvTT+fY9kdQx8H5OoSMEbMZYgI/Nb3j8hpA5phTBL72BSNpY0DacQe
        aBeIqUbw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwVWm-004AbP-Dq; Fri, 27 Oct 2023 22:42:04 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bage@debian.org>
CC:     linux-xfs@vger.kernel.org, pkg-grub-devel@alioth-lists.debian.net
Subject: Processed: Re: Bug#1054644: xfsprogs-udeb: causes D-I to fail,
 reporting errors about missing partition devices
Message-ID: <handler.s.B1054644.1698446291992022.transcript@bugs.debian.org>
References: <08691503-1a3a-4149-82b8-749e0606159b@debian.org>
 <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Package: grub2 xfsprogs-udeb
X-Debian-PR-Source: grub2 xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Fri, 27 Oct 2023 22:42:04 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing control commands:

> reassign -1 grub2
Bug #1054644 [xfsprogs-udeb] xfsprogs-udeb: causes D-I to fail, reporting e=
rrors about missing partition devices
Bug reassigned from package 'xfsprogs-udeb' to 'grub2'.
No longer marked as found in versions xfsprogs/6.5.0-1.
Ignoring request to alter fixed versions of bug #1054644 to the same values=
 previously set

--=20
1054644: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1054644
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
