Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6C8OdJB025959 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 03:24:40 -0500
Date: Thu, 12 Jul 2012 04:24:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] xfs: regression fixes for 3.5-rc7
Message-ID: <20120712082433.GA5553@infradead.org>
References: <1342042843-1773-1-git-send-email-david@fromorbit.com>
	<20120711224822.GQ10196@sgi.com> <20120711235227.GA19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120711235227.GA19223@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Jul 12, 2012 at 09:52:27AM +1000, Dave Chinner wrote:
> > IMO we should also consider "xfs: prevent recursion in xfs_buf_iorequest", from
> > Christoph.
> 
> Yes, I think so. You don't have to wait for me to propose fixes to
> suggest other patches that could be considered for Linus updates... ;)

I'm pretty sure I suggesteds these specificly for 3.5-rc.

Note that Linus is going to release 3.5 soon, so we should rush to both
get the 3.5 fixes and the remaining 3.6 queue in.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
