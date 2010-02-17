Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HMsEiv005750 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 16:54:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4944213B5077
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:55:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	BGEqjJU2BGJLu5As for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2010 14:55:32 -0800 (PST)
Date: Thu, 18 Feb 2010 09:55:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: kill xfs_lrw.h
Message-ID: <20100217225529.GU28392@discord.disaster>
References: <20100217193613.GB21840@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217193613.GB21840@infradead.org>
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

On Wed, Feb 17, 2010 at 02:36:13PM -0500, Christoph Hellwig wrote:
> Move the two declarations to better fitting headers now that xfs_lrw.c
> is gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
