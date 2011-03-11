Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2BA8GiJ154619 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 04:08:26 -0600
Date: Fri, 11 Mar 2011 05:11:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: rework "dmapi" subtree build mechanism
Message-ID: <20110311101107.GD11879@infradead.org>
References: <201103041937.p24Jbk5W004828@stout.americas.sgi.com>
	<20110310172943.GD13390@infradead.org>
	<1299795372.2573.79.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299795372.2573.79.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> I'll add a boilerplate GPL statement in these new files.
> What I used was simply mimicing what was present in the
> other Makefiles.
> 
> In order to avoid re-sending this big patch, may I get
> your signoff/reviewed-by on that plan?

I haven't looked at every detail, but it looks sane and close enough to
the normal build system to me, so:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
