Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KFd1m1097475 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 10:39:02 -0500
Date: Wed, 20 Jun 2012 10:39:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620153912.GJ2676@sgi.com>
References: <20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com> <20120620055619.GA30705@dastard>
	<20120620060400.GA5617@infradead.org>
	<20120620062931.GC30705@dastard> <20120620064612.GG30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620064612.GG30705@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Dave,

On Wed, Jun 20, 2012 at 04:46:12PM +1000, Dave Chinner wrote:
> > FWIW, Ben, there's a few reviewed bug fixes on the list that are
> > outstanding that need to go to Linus ASAP:
> > 
> > http://oss.sgi.com/archives/xfs/2012-06/msg00154.html
> > http://oss.sgi.com/archives/xfs/2012-06/msg00134.html
> > http://oss.sgi.com/archives/xfs/2012-06/msg00056.html (regression)
> > 
> > Can you take care of them please?
> 
> Add to that:
> 
> http://oss.sgi.com/archives/xfs/2012-05/msg00352.html
> 
> which also needs to go to Linus to fix an issue introduced in the
> 3.5-rc1 merge...

Yep, agreed.  That is one of the others that I'd like to go in a 3.5 rc merge.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
