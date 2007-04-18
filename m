Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 16:57:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3INvofB016054
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 16:57:52 -0700
Date: Thu, 19 Apr 2007 09:57:41 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] kill macro noise in xfs_dir2*.h
Message-ID: <20070418235741.GK48531920@melbourne.sgi.com>
References: <20070418175859.GB18315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418175859.GB18315@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Apr 18, 2007 at 07:59:00PM +0200, Christoph Hellwig wrote:
> Remove all the macros that just give inline functions uppercase names.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Added to my QA tree.

Thanks, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
