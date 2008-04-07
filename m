Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 15:02:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m37M2ehi003823
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 15:02:44 -0700
Date: Tue, 8 Apr 2008 08:03:09 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] don't validate symlink target component length
Message-ID: <20080407220309.GG108924158@sgi.com>
References: <20080407095745.GA11772@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407095745.GA11772@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Apr 07, 2008 at 11:57:45AM +0200, Christoph Hellwig wrote:
> This validtion is not posix conform and no other Linux filesystem does
> it.

Beat me to it, Christoph. ;)

I'll run it through QA.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
