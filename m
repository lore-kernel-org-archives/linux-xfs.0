Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:15:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONFVpb010638
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:15:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B886A32B96C
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:16:42 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id NqncCT7Rq2smW8Ha for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:16:42 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:16:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/15] small cleanups in xfs_btree.c
Message-ID: <20080724231639.GB15438@disturbed>
References: <20080723200820.GB7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200820.GB7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:08:20PM +0200, Christoph Hellwig wrote:
>  - remove unneeded xfs_btree_get_block forward declaration
>  - move xfs_btree_firstrec next to xfs_btree_lastrec

looks good to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
