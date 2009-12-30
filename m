Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBUMPlKf058651 for <xfs@oss.sgi.com>; Wed, 30 Dec 2009 16:25:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDB7A1C23234
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2009 14:26:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	GUnckRb5I9eLMsH5 for <xfs@oss.sgi.com>;
	Wed, 30 Dec 2009 14:26:34 -0800 (PST)
Date: Thu, 31 Dec 2009 09:26:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] repair: add more fresspace btree checks
Message-ID: <20091230222631.GC13802@discord.disaster>
References: <20091201150503.958283878@bombadil.infradead.org>
	<20091201151037.542119951@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091201151037.542119951@bombadil.infradead.org>
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

On Tue, Dec 01, 2009 at 10:05:05AM -0500, Christoph Hellwig wrote:
> Port over additional checks for the freespace btrees from xfs_db, to get
> the same btree checking coverage as in xfs_check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good - the additional informational output will be useful when
problems are found.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
