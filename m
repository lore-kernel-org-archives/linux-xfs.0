Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 23:56:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U6uH1g010026
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:56:17 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9115BED4BCA
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:57:29 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id VjC3jCiBF3ZNYP1L for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:57:29 -0700 (PDT)
Date: Wed, 30 Jul 2008 16:57:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/21] implement semi-generic xfs_btree_new_root
Message-ID: <20080730065721.GS13395@disturbed>
References: <20080729193143.GS19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193143.GS19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:43PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> Add a xfs_btree_new_root helper for the alloc and ialloc btrees.  The bmap
> btree needs it's own version and is not converted.
> 
> [hch: split out from bigger patch and minor adaptions]
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
