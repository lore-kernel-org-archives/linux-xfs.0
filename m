Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 15:53:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5MMr0OB002165
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 15:53:00 -0700
Date: Mon, 23 Jun 2008 08:53:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080622225355.GD11558@disturbed>
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <20080620052716.GA2022@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620052716.GA2022@anita>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miquel van Smoorenburg <mikevs@xs4all.net>, Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com

On Fri, Jun 20, 2008 at 07:27:17AM +0200, Konstantin Kletschke wrote:
> Am 2008-06-13 13:08 +1000 schrieb Dave Chinner:
> 
> > This commit in 2.6.26 will probably fix it.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3
> 
> If I am correct, this fix is included in 2.6.26-rc6:

Yes, so if you're seeing it again then there's a different problem.

Please provide a pointer to a xfs_metadump image of the filesystem
and the steps to reproduce the error from the image so we can
get to the bottom of it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
