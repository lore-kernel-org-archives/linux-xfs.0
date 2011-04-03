Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p33AtBCi101846 for <xfs@oss.sgi.com>; Sun, 3 Apr 2011 05:55:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3655E15AE1FA
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2011 03:58:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GikGlVZu1jyMkIy2 for
	<xfs@oss.sgi.com>; Sun, 03 Apr 2011 03:58:25 -0700 (PDT)
Date: Sun, 3 Apr 2011 06:58:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix xfs_debug warnings
Message-ID: <20110403105823.GA3872@infradead.org>
References: <20110402181340.GA12639@infradead.org>
	<20110402220905.GA1861@infradead.org>
	<20110403001648.GH6957@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110403001648.GH6957@dastard>
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
Cc: xfs@oss.sgi.com

On Sun, Apr 03, 2011 at 10:16:48AM +1000, Dave Chinner wrote:
> Looks good, though I don't get those warnings using gcc-4.4.4. I
> guess it's gcc-4.6 issuing the warnings?

Debian testing recently updated to gcc 4.5.2 from gcc 4.4.x, I think
that's when I started to see them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
