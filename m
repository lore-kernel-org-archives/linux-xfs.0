Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59176 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933235AbcK1Qfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 11:35:43 -0500
Received: from tux.wizards.de (p579D0799.dip0.t-ipconnect.de [87.157.7.153])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 3B36841601BB
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 17:35:41 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id AD92711C0EBF
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 17:35:40 +0100 (CET)
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: New package locations of xfsprogs vs. xfsdump
Message-ID: <583C5CDC.6050009@applied-asynchrony.com>
Date: Mon, 28 Nov 2016 17:35:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I just bumped my xfsprogs on Gentoo to 4.8.0 to use the new download location
at kernel.org and noticed that xfsdump is still at sgi.com, even though it has
an empty directory at https://www.kernel.org/pub/linux/utils/fs/xfs/xfsdump/.

Is xfsdump supposed to be there as well or has that migration just not
happened yet? Just asking for packaging reasons.

thanks,
Holger

