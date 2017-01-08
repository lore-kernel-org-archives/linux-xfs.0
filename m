Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43211 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752776AbdAHSKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 13:10:11 -0500
Date: Sun, 8 Jan 2017 10:10:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: minleft fixes V2
Message-ID: <20170108181002.GA3732@birch.djwong.org>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <20170105012159.GS1859@eguan.usersys.redhat.com>
 <20170105020105.GC17846@birch.djwong.org>
 <20170108103647.GD26451@lst.de>
 <20170108160959.GD62847@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170108160959.GD62847@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Sun, Jan 08, 2017 at 11:10:00AM -0500, Brian Foster wrote:
> On Sun, Jan 08, 2017 at 11:36:47AM +0100, Christoph Hellwig wrote:
> > On Wed, Jan 04, 2017 at 06:01:05PM -0800, Darrick J. Wong wrote:
> > > Ok, sounds good.  I just sent out my first attempt at a pull request to Linus,
> > > so I'll queue this series for another pull req. after that.
> > 
> > I'll resend with a few minor updates based on the comments from Brian
> > in a few days, so this should be ready for -rc4.
> 
> So I just noticed that this series was merged into for-next (which iiuc
> is easily fixable, yes?).

Yep.  for-next can be rebased.

> Christoph already mentioned he was sending a new variant... but
> juuuuuust a note that not all of these patches had a reviewed-by yet
> either. ;) 

<nod> I'm aware; I'll be more patient next time. :)

TBH I was also curious to have the kbuild robot / linux-next pick up a
changeset that wasn't terribly likely to break anything else, just to
see how they run...

--D

> 
> Brian
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
