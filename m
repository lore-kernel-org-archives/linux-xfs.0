Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 17:53:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U0riNT005476
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 17:53:44 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29196ECFFDE
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 17:54:56 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id afyojEOjL7zgg7Ok for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 17:54:56 -0700 (PDT)
Date: Wed, 30 Jul 2008 10:54:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/21] add new btree statistics
Message-ID: <20080730005425.GH13395@disturbed>
References: <20080729193039.GH19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193039.GH19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, Dave Chinner <dgc@sgi.com>

On Tue, Jul 29, 2008 at 09:30:39PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> Introduce statistics coverage of all the btrees and cover
> all the btree operations, not just some.
> 
> Invaluable for determining test code coverage of all the btree
> operations....
> 
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Still looks fine to me ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
