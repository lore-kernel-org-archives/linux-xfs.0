Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 23:19:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5K6IxUX021116
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 23:18:59 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96D69D0200F
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 23:19:57 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 3kuGX0eDmprW08SZ for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 23:19:57 -0700 (PDT)
Date: Fri, 20 Jun 2008 08:18:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill XFS_PURGE_INODE
Message-ID: <20080620061841.GA26777@lst.de>
References: <20080616062634.GA5971@lst.de> <200806161015.12363.dchinner@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806161015.12363.dchinner@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <dchinner@agami.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jun 16, 2008 at 10:15:12AM -0700, Dave Chinner wrote:
> On Sunday 15 June 2008 11:26 pm, Christoph Hellwig wrote:
> > Just a useless alias for IRELE.
> 
> Looks sane.

Could someone of the SGI people commit this rather trivial patch?
