Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6E2dFYB121130 for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 21:39:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 113F214BDC22
	for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 19:48:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sdy1jC345NJ1hOPg for
	<xfs@oss.sgi.com>; Tue, 13 Jul 2010 19:48:18 -0700 (PDT)
Date: Tue, 13 Jul 2010 22:42:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test the aio unwrittent extent conversion race
Message-ID: <20100714024207.GA15995@infradead.org>
References: <20100626114334.GA15157@infradead.org>
	<20100712063217.GF25335@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100712063217.GF25335@dastard>
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

On Mon, Jul 12, 2010 at 04:32:17PM +1000, Dave Chinner wrote:
> > +# creator
> > +owner=dchinner@redhat.com
> 
> Maybe not. ;)
> 
> Otherwise looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

That's what you get for copy & pasting test stubs.  Pushed out with the
owner fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
