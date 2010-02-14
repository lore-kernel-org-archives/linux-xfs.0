Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ENCZtc005987 for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 17:12:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF83E1CE009
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2010 15:13:50 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	v2Q2RSEqDV4fVSuV for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2010 15:13:50 -0800 (PST)
Date: Mon, 15 Feb 2010 10:13:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix awk syntax error in 219
Message-ID: <20100214231347.GD28392@discord.disaster>
References: <20100214220725.GA14927@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100214220725.GA14927@infradead.org>
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

On Sun, Feb 14, 2010 at 05:07:25PM -0500, Christoph Hellwig wrote:
> There's one brace too many here - this was pointed out in the review
> but slipped back into the commited patch.
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
