Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46730 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753541AbdHUTER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 15:04:17 -0400
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1djrxK-0007qm-Rh
        for linux-xfs@vger.kernel.org; Mon, 21 Aug 2017 21:01:46 +0200
Date: Mon, 21 Aug 2017 21:04:15 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Support for data CRC
Message-ID: <20170821190414.long2535xppcxvvd@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

my understanding is that only metadata is protected by CRC in the new
on-disk format. Are there any plans to also protect data?

Sebastian
