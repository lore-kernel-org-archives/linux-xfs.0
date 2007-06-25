Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 03:31:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5PAVLdo005904
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 03:31:25 -0700
Date: Mon, 25 Jun 2007 20:31:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: SLUB Allocator?
Message-ID: <20070625103116.GA31489@sgi.com>
References: <Pine.LNX.4.64.0706211241290.31303@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706211241290.31303@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 21, 2007 at 12:42:03PM -0400, Justin Piszcz wrote:
> Is there any XFS filesystem performance benefit using the new SLUB 
> allocator?

/me shrugs

When it grows memory defrag of caches, yes. Otherwise I can't
see there being any noticable difference.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
