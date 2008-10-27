Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 16:41:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RNfR1g023204
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:41:27 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E2331312C30
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:41:26 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id kFy0aWzeT32z3u8t for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:41:26 -0700 (PDT)
Date: Tue, 28 Oct 2008 10:41:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] remove xfs_vfsops.h
Message-ID: <20081027234124.GL4985@disturbed>
References: <20081027133337.GD31125@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133337.GD31125@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:33:37AM -0400, Christoph Hellwig wrote:
> The only think left is xfs_do_force_shutdown which already has a defintion
> in xfs_mount.h, too.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by; Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
