Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:25:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A4PtE0030261
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:25:55 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64B65A32661
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 21:27:35 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id nBtXD44IhwJZe6Ic for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 21:27:35 -0700 (PDT)
Date: Fri, 10 Oct 2008 15:27:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fix barrier fail detection
Message-ID: <20081010042732.GC8181@disturbed>
References: <20081009130042.GA21071@lst.de> <48EEAC1A.2080309@sgi.com> <48EED73F.1010208@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EED73F.1010208@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, toei.rei@stargazer.at

On Fri, Oct 10, 2008 at 03:17:03PM +1100, Timothy Shimmin wrote:
> Timothy Shimmin wrote:
.....
> > Actually, probably need to update the comment for this one.
.....

> i.e. something like:

Looks fine to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
