Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:28:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONS6Mb017184
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:28:06 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D88932BB8F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:29:17 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id O4zOJyOGN4uULBlE for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:29:17 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:29:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/15] add a long pointers flag to xfs_btree_cur
Message-ID: <20080724232915.GG15438@disturbed>
References: <20080723200853.GG7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200853.GG7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:08:53PM +0200, Christoph Hellwig wrote:
> Add a flag to the xfs btree cursor when using long (64bit) block pointers
> instead of checking btnum == XFS_BTNUM_BMAP.

Very sane idea ;)

Looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
