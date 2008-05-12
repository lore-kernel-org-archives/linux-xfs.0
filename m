Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 09:40:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4CGeGfe027560
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:40:20 -0700
Received: from kernel.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2FC8158C1C
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:41:00 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [87.55.233.238]) by cuda.sgi.com with ESMTP id NIF7ZThKWZpiB4FJ for <xfs@oss.sgi.com>; Mon, 12 May 2008 09:41:00 -0700 (PDT)
Date: Mon, 12 May 2008 18:40:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Message-ID: <20080512164053.GD16217@kernel.dk>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805121726.15576.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805121726.15576.alistair@devzero.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, neilb@suse.de

On Mon, May 12 2008, Alistair John Strachan wrote:
> I've been getting this since -rc1. It's still present in -rc2, so I thought 
> I'd bug some people. Everything seems to be working fine.
> 
> I'm not sure who's to blame here so I've added a few people to CC; if I've 
> done so in error, sorry for the noise.
> 
> The taint is from loading a custom (fixed) DSDT which I've been doing for 
> ages, and which shouldn't affect this trace.

Neil should have a pending patch for this warning. Don't worry about it
:-)

-- 
Jens Axboe
