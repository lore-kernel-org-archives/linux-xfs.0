Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6TsPx248644 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:29:54 -0500
Date: Wed, 20 Jun 2012 02:29:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620062950.GA5467@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619171153.GD2676@sgi.com>
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
To: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Tue, Jun 19, 2012 at 12:11:53PM -0500, Ben Myers wrote:
>  I think that Jan
> is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> based upon Dave's suggestions.

Given that the patch that this patch fixes already is in Linus tree
since 3.5-rc1 Jan's fix should be ontop of Linus' tree and be sent to
him ASAP.  Jan, can you resend it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
