Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBG8f0kt019404 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 02:41:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02DCD1F72D2
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 00:42:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hqQUUcHG9hHl1Smz for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 00:42:54 -0800 (PST)
Date: Thu, 16 Dec 2010 03:42:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/10] writeback updates V2
Message-ID: <20101216084250.GA30107@infradead.org>
References: <20101210084215.259628825@bombadil.infradead.org>
	<20101215232606.GJ9925@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101215232606.GJ9925@dastard>
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

On Thu, Dec 16, 2010 at 10:26:07AM +1100, Dave Chinner wrote:
> On Fri, Dec 10, 2010 at 03:42:15AM -0500, Christoph Hellwig wrote:
> >  - add IO_DIRECT per Dave's review comment
> >  - fix up a commit message as per Dave's review comment
> >  - add Reviewed-by: tags for Dave's reviews
> 
> Christoph, do you want me to add this to my xfs-for-2.6.38 branch so
> it is easier to test with all the other pending changes we have for
> 2.6.38?

That's fine with me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
