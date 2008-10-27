Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 16:41:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RNf2T5023021
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:41:03 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E48F11312C2B
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:41:01 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Lhuiqaknq33k8HSy for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:41:01 -0700 (PDT)
Date: Tue, 28 Oct 2008 10:40:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] remove xfs_vfs.h
Message-ID: <20081027234047.GK4985@disturbed>
References: <20081027133334.GC31125@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133334.GC31125@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:33:34AM -0400, Christoph Hellwig wrote:
> The only thing left are the forced shutdown flags and freeze macros which
> fit into xfs_mount.h much better.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by; Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
