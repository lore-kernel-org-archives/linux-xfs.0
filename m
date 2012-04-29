Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLoTBJ162101 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:50:29 -0500
Date: Sun, 29 Apr 2012 17:50:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 29/37 V3] xfs: move busy extent handling to it's own file
Message-ID: <20120429215027.GH19889@infradead.org>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-30-git-send-email-david@fromorbit.com>
	<20120423175725.GG16881@sgi.com> <20120424002502.GS9541@dastard>
	<4F96CD24.2070805@sgi.com> <4F96EC97.3050404@sgi.com>
	<20120429103943.GQ9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429103943.GQ9541@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

I would have called it xfs_busy_extent.h, but given how far you are with
the series it's really not worth bike sheeding about this detail.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
