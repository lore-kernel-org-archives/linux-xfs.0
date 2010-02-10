Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AFjqHG058696 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 09:45:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E0F41CBD0EB
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 07:47:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7gl21Rwo0GnX5FG8 for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 07:47:06 -0800 (PST)
Date: Wed, 10 Feb 2010 10:47:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31
	xfs_fs_destroy_inode: cannot reclaim)
Message-ID: <20100210154705.GA28809@infradead.org>
References: <4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
	<20100209103157.GA5197@infradead.org>
	<4B72A9D1.8030101@news-service.com>
	<20100210145508.GA29047@infradead.org>
	<4B72D3F3.2040308@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B72D3F3.2040308@news-service.com>
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

On Wed, Feb 10, 2010 at 04:42:43PM +0100, Patrick Schreurs wrote:
> Have any of these patches been sent to the stable team? And have these  
> patches been submitted to the upcoming 2.6.33 kernel?

Everything before the current test patches is in 2.6.33-rc, I'm not
sure what has made it to stable yet, but if I remember correctly
Dave was going to send his fixes to -stable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
