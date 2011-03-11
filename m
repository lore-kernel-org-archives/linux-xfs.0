Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2BA7Tva154558 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 04:07:39 -0600
Date: Fri, 11 Mar 2011 05:10:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: some refinements on "make depend"
Message-ID: <20110311101009.GB11879@infradead.org>
References: <201103041937.p24Jbfh5004820@stout.americas.sgi.com>
	<20110310172644.GC13390@infradead.org>
	<1299794976.2573.72.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299794976.2573.72.camel@doink>
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

On Thu, Mar 10, 2011 at 04:09:36PM -0600, Alex Elder wrote:
> My intention was to work toward unifying all the user space
> stuff, basically in line with what you suggest.
> 
> This is part of a flurry of changes related to the xfstests
> dmapi subtree.  One of the things I needed to do was populate
> a set of new Makefiles there, and I guess in looking into
> that I found I didn't like the way the dependencies were done,
> and the changes I made to address that ended up in this patch.
> 
> I'll hold off on this patch and will reconsider it once
> I get the more substantive dmapi changes in.

Feel free to put it in for now as a transition step.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
