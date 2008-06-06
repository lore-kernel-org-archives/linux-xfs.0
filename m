Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jun 2008 22:16:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m565GqOp020200
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2008 22:16:53 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF1881FAC74
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2008 22:17:47 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 1tyQIL7Q5giYX6Zs for <xfs@oss.sgi.com>; Thu, 05 Jun 2008 22:17:47 -0700 (PDT)
Date: Fri, 6 Jun 2008 15:17:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 982930 - fix dir2 shortform structures on ARM old ABI
Message-ID: <20080606051744.GN10720@disturbed>
References: <20080606050858.56FB758C4C3F@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606050858.56FB758C4C3F@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tim Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 06, 2008 at 03:08:58PM +1000, Tim Shimmin wrote:
> Pack some shortform dir2 structures for the ARM old ABI architecture.
> 
> Finally put this in for Eric and the users of this arch.

Don't forget the matching userspace patch ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
