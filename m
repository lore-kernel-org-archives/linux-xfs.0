Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29567 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756154AbdADGfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 01:35:44 -0500
Date: Tue, 3 Jan 2017 22:35:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: xfs-4.10-misc-fixes-5 updated to ff97f23
Message-ID: <20170104063515.GB14034@birch.djwong.org>
References: <20170104054721.GC14031@birch.djwong.org>
 <20170104061141.GA4265@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104061141.GA4265@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, f@birch.djwong.org
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 03, 2017 at 10:11:41PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 03, 2017 at 09:47:21PM -0800, Darrick J. Wong wrote:
> > Patches often get missed, so please check if your outstanding
> > patches were in this update. If they have not been in this update,
> > please resubmit them to linux-xfs@vger.kernel.org so they can be
> > picked up in the next update.
> > 
> > I intend to send these four bugfixes to Linus later this week, but
> > thought I'd run it by the list first to see if anyone spots anything
> > obviously broken.
> 
> I'd really like to get the minleft fixes reviewed and to Linus:
> 
> http://www.spinics.net/lists/linux-xfs/msg03036.html

I was wondering if Eryu ever tried his reproducer with this series
applied?  Also, in reminding myself what went on during the v1 review
thread I also started having a few questions... (see list)

--D
