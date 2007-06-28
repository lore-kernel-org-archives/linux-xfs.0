Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 22:08:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S58otL004645
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 22:08:52 -0700
Date: Thu, 28 Jun 2007 15:08:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Message-ID: <20070628050837.GG989688@sgi.com>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan> <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

On Wed, Jun 27, 2007 at 07:20:42PM -0400, Justin Piszcz wrote:
> For drives with 16MB of cache (in this case, raptors).

That's four (4) drives, right?

If so, how do you get a block read rate of 578MB/s from
4 drives? That's 145MB/s per drive....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
