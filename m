Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 00:14:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S6wHDa025478
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:58:18 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC2881B66327
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:58:16 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id IEElmqGm7uaTIBny for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:58:16 -0700 (PDT)
Date: Tue, 28 Oct 2008 17:58:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] kill XFS_DINODE_VERSION_ defines
Message-ID: <20081028065810.GU4985@disturbed>
References: <20081027133914.GG1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133914.GG1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:14AM -0400, Christoph Hellwig wrote:
> These names don't add any value at all over just using the numerical
> values.
> 
> (First sent on October 9th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
