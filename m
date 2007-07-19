Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 15:44:23 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JMiHbm019226
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 15:44:19 -0700
Date: Thu, 19 Jul 2007 15:29:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update
In-Reply-To: <469F7329.9080603@sgi.com>
Message-ID: <alpine.LFD.0.999.0707191528250.27249@woody.linux-foundation.org>
References: <469F7329.9080603@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Tim Shimmin wrote:
> 
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

Ok, this got some conflicts with Nick's VM fault patches, but I fixed them 
up since they looked trivial, and pushed out the result. Please do verify 
that it all works and makes sense, though...

		Linus
