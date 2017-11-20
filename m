Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34080 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdKTRaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 12:30:22 -0500
Date: Mon, 20 Nov 2017 09:30:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v10 00/27] xfsprogs-4.15: online scrub/repair support
Message-ID: <20171120173009.GG5130@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
 <3371427.NcZX6d9uP5@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3371427.NcZX6d9uP5@merkaba>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Nov 17, 2017 at 10:52:47PM +0100, Martin Steigerwald wrote:
> Hello Darrick.
> 
> Darrick J. Wong - 17.11.17, 22:00:
> > If you're going to start using this mess, you probably ought to just
> > pull from my git tree for xfsprogs[1].  This series relies on the
> > libfrog patches sent earlier.  Kernel support will appear in 4.15-rc1.
> 
> No extraordinary way to eat your data?
> 
> I am a tad bit disappointed.

Please have patience until I get around to posting online *repair*. :)

> Okay, jokes aside: Thank you very much for this work on XFS. Sometimes I would 
> not be surprised if you at one point would even have a go at implementing 
> snapshots for XFS. (Did he actually say the snapshot word. He didn´t, or did 
> he?)

/me wonders if amir will get there first via overlayfs...

--D

> Thanks,
> -- 
> Martin
