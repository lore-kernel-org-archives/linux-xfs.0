Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Aug 2008 17:32:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m780WWeC012976
	for <xfs@oss.sgi.com>; Thu, 7 Aug 2008 17:32:32 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32D04375830
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2008 17:33:46 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id LsKblLLKHZIpZQjG for <xfs@oss.sgi.com>; Thu, 07 Aug 2008 17:33:46 -0700 (PDT)
Date: Fri, 8 Aug 2008 10:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PATCH] trivial xfs_remove comment fixup
Message-ID: <20080808003344.GB24344@disturbed>
References: <20080807215849.GA11345@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807215849.GA11345@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 07, 2008 at 11:58:49PM +0200, Christoph Hellwig wrote:
> The dp to ip comment should be for the unconditional xfs_droplink
> call, and the "." link obviously only exists for directories,
> so it should be in the is_dir conditional.

Ack.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
