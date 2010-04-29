Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TKalnp099499 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 15:36:48 -0500
Subject: Re: [PATCH 11/11] xfs: mark xfs_iomap_write_ helpers static
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100428123016.553009023@bombadil.infradead.org>
References: <20100428122850.075189557@bombadil.infradead.org>
	<20100428123016.553009023@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 15:37:53 -0500
Message-ID: <1272573473.3221.143.camel@doink>
Mime-Version: 1.0
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

On Wed, 2010-04-28 at 08:29 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-iomap-cleanup-12)
> And also drop a useless argument to xfs_iomap_write_direct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_iomap.c
> ===================================================================


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
