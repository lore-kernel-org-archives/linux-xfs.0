Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 01:07:52 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5S87itL020901
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 01:07:45 -0700
Date: Thu, 28 Jun 2007 04:07:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
In-Reply-To: <20070628050837.GG989688@sgi.com>
Message-ID: <Pine.LNX.4.64.0706280407420.1406@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan> <20070628050837.GG989688@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

10 disks total.

Justin.

On Thu, 28 Jun 2007, David Chinner wrote:

> On Wed, Jun 27, 2007 at 07:20:42PM -0400, Justin Piszcz wrote:
>> For drives with 16MB of cache (in this case, raptors).
>
> That's four (4) drives, right?
>
> If so, how do you get a block read rate of 578MB/s from
> 4 drives? That's 145MB/s per drive....
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
