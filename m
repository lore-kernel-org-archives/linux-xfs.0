Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KHZjnd099044 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 12:35:45 -0500
Subject: Re: [PATCH 3/4] xfstests: fix quota detection
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101015222913.GC3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222913.GC3781@infradead.org>
Date: Wed, 20 Oct 2010 12:36:55 -0500
Message-ID: <1287596215.2284.96.camel@doink>
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

On Fri, 2010-10-15 at 18:29 -0400, Christoph Hellwig wrote:
> Even if the kernel has quota support built in most filesystems still
> don't support it.  As there's no good way to find out if a filesystem
> supports quotas hardcode the list of filesystems that do support
> quotas.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
