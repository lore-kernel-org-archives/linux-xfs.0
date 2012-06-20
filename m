Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KFpX6l099600 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 10:51:34 -0500
Date: Wed, 20 Jun 2012 10:51:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620155147.GL2676@sgi.com>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com>
	<20120620062950.GA5467@infradead.org>
	<20120620063729.GE30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620063729.GE30705@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Hey Dave,

On Wed, Jun 20, 2012 at 04:37:29PM +1000, Dave Chinner wrote:
> On Wed, Jun 20, 2012 at 02:29:50AM -0400, Christoph Hellwig wrote:
> > On Tue, Jun 19, 2012 at 12:11:53PM -0500, Ben Myers wrote:
> > >  I think that Jan
> > > is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> > > based upon Dave's suggestions.
> 
> > Given that the patch that this patch fixes already is in Linus tree
> > since 3.5-rc1 Jan's fix should be ontop of Linus' tree and be sent to
> > him ASAP.  Jan, can you resend it?
> 
> He already did that - I linked to the v2 version of the patch the
> previous email...

Great!  I missed that too.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
