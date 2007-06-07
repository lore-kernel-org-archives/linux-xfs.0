Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 16:24:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l57NOTWt025708
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 16:24:30 -0700
Date: Fri, 8 Jun 2007 09:24:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] kill macro noise in xfs_dir2*.h
Message-ID: <20070607232418.GJ85884050@sgi.com>
References: <20070418175859.GB18315@lst.de> <20070604143602.GA9081@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604143602.GA9081@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Jun 04, 2007 at 04:36:02PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 18, 2007 at 07:59:00PM +0200, Christoph Hellwig wrote:
> > Remove all the macros that just give inline functions uppercase names.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch still hasn't made it to mainline, so here's a version
> rediffed for latest mainline because it's required for the next patch

It's in my test tree - I just haven't had a chance to review it
properly and check it in yet because of all the other stuff I've got
to do right now.  Cleanups are not high priority compared to finding
and fixing the numerous data corruption problems that have been
uncovered recently...

At least it's being QA'd regularly. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
