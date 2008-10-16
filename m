Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 15:42:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GMgVJ3030868
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:42:31 -0700
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63523509244
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:44:15 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com with ESMTP id IHkulAAuCEz3zu92 for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:44:15 -0700 (PDT)
Date: Thu, 16 Oct 2008 15:39:06 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016223906.GA18144@kroah.com>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016173529.GA13038@kroah.com> <20081016181044.GA16092@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016181044.GA16092@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 02:10:44PM -0400, Christoph Hellwig wrote:
> On Thu, Oct 16, 2008 at 10:35:29AM -0700, Greg KH wrote:
> > Is this patch already in Linus's tree?  If so, do you have a git commit
> 
> 6c5e51dae2c37127e00be392f40842e08077e96a

Thanks, now queued up.

greg k-h
