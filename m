Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 16:25:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NNPt4B005899
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 16:25:55 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AA64191E685
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 16:27:05 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Rvh0gtwUduGTIKxY for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 16:27:05 -0700 (PDT)
Date: Thu, 24 Jul 2008 09:27:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] more vnode related macro cleanups
Message-ID: <20080723232702.GP6761@disturbed>
References: <20080723194930.GA6188@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723194930.GA6188@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 09:49:30PM +0200, Christoph Hellwig wrote:
> As Dave's cleanups got in so fast (thanks Niv!) I'll give these patches
> a spin to.  They are all over so I'd love to get them in fast too and
> get the leftover bhv_vnode_t bits sorted out ASAP.

This series applies on a pristine tree? Not on top of your
other changes (like the sanitize init vnode one)? Several of
the patches won't apply to my incoming branch because of that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
