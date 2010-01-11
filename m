Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BMWw6Y185450 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 16:32:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83E821C42DB6
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 14:33:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TAgH93c1rHyNmCfi for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 14:33:54 -0800 (PST)
Date: Mon, 11 Jan 2010 17:33:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10] Perag lookup rework
Message-ID: <20100111223354.GA23551@infradead.org>
References: <1263210469-22171-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263210469-22171-1-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:47:39PM +1100, Dave Chinner wrote:
> This is the previous set of patches all put together in the one series
> for the current xfs-dev tree.
> 
> Patch 10 is a new patch - it embeds the busy extent list into the perag
> structure rather than leaving as a separate allocation.

All patches, including the new last one look good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
