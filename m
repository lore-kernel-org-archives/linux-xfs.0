Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:43:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751h6Xf025594
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:43:06 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0BA235BEEC
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:44:19 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 0e2F5YC3H6nP2svr for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:44:19 -0700 (PDT)
Date: Tue, 5 Aug 2008 11:43:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/26] kill xfs_bmbt_log_block
Message-ID: <20080805014348.GP6119@disturbed>
References: <20080804013602.GZ8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013602.GZ8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:36:02AM +0200, Christoph Hellwig wrote:
> Only one caller left, which can just use xfs_btree_log_block if we export it.

looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
