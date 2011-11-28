Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASI323c247425 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 12:03:03 -0600
Date: Mon, 28 Nov 2011 13:03:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: fix attr2 vs large data fork assert
Message-ID: <20111128180300.GA12730@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.458494771@bombadil.infradead.org>
	<20111128180136.GS29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128180136.GS29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 28, 2011 at 12:01:36PM -0600, Ben Myers wrote:
> This is missing some cleanups that you did for v2.  I'll use that
> version, unless you have an objection.

Looks like I got lost in my maze of trees.  Pick whichever you want.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
