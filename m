Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Aug 2006 01:19:24 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7A8IxDW030899
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 01:19:01 -0700
Date: Wed, 9 Aug 2006 23:58:36 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: XFS fix for 2.6.18-rc5
Message-ID: <20060810065836.GA27205@kroah.com>
References: <20060810154817.A2591606@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060810154817.A2591606@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, xfs@oss.sgi.com

On Thu, Aug 10, 2006 at 03:48:18PM +1000, Nathan Scott wrote:
> Hi Greg,
> 
> Please pull from:
> 	git://oss.sgi.com:8090/nathans/xfs-rc-2.6
> 
> This will update the following files:
> 
>  fs/xfs/xfs_alloc.c |  103 +++++++++++++++++++++++++++-------------------------
>  1 files changed, 54 insertions(+), 49 deletions(-)

Pulled from, and pushed out.

thanks,

greg k-h
