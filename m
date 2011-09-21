Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LIjHo7166678 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 13:45:17 -0500
Subject: Re: [PATCH 2/4] libxfs: save errno before possibly overwriting it
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110920220030.374670125@bombadil.infradead.org>
References: <20110920215917.508421839@bombadil.infradead.org>
	<20110920220030.374670125@bombadil.infradead.org>
Date: Wed, 21 Sep 2011 13:45:10 -0500
Message-ID: <1316630710.5872.14.camel@doink>
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

On Tue, 2011-09-20 at 17:59 -0400, Christoph Hellwig wrote:
> Save away errno for a later error return before possibly overwriting
> it in fprintf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
