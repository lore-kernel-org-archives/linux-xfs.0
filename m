Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C2q6rW006715 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 21:52:06 -0500
Subject: Re: [PATCH 10/11] xfs: remove leftovers of the old btree tracing code
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110710205018.724144355@bombadil.infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205018.724144355@bombadil.infradead.org>
Date: Mon, 11 Jul 2011 21:52:02 -0500
Message-ID: <1310439122.3044.3.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> Remove various bits left over from the old kdb-only btree tracing code, but
> leave the actual trace point stubs in place to ease adding new event based
> btree tracing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It doesn't look like I signed off on this, but I thought
I had.  I haven't been using these so it's fine with me
that they go.  It's good that you're leaving the stubs
as placeholders--they should be populated at some point.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
