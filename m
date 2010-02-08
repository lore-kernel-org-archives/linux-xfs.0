Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18JfF31155939 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 13:41:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9E9D1388AA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 11:42:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Uu0wuNsPLFp9FWca for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 11:42:27 -0800 (PST)
Date: Mon, 8 Feb 2010 14:42:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31
	xfs_fs_destroy_inode: cannot reclaim)
Message-ID: <20100208194226.GD9527@infradead.org>
References: <4AF0422D.1070104@news-service.com>
	<20091114162126.GB17658@infradead.org>
	<4B0A8075.8080008@news-service.com>
	<20091211115932.GA20632@infradead.org>
	<4B3F9F88.9030307@news-service.com>
	<20100107110446.GA13802@discord.disaster>
	<4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B6706CE.1020207@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On Mon, Feb 01, 2010 at 05:52:30PM +0100, Patrick Schreurs wrote:
> Hello Dave,
>
> I'm afraid we had another crash a few days ago. Have a look at the  
> screenshot. Can you make anything out of it? This server is running  
> 2.6.32.3 with your inode-reclaim patch applied and XFS_DEBUG still 
> enabled.

Just wondering, which set of patches is this exactly?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
