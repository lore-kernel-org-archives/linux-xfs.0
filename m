Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:16:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T6GItL024418
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:16:21 -0700
Date: Fri, 29 Jun 2007 16:16:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: xfs_bmap '-v' flag has no effect on a realtime file system
Message-ID: <20070629061611.GP31489@sgi.com>
References: <op.tun6efyd3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tun6efyd3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jun 29, 2007 at 04:16:53PM +1000, Barry Naujok wrote:
> It's rather confusing when you run xfs_bmap -v on a realtime file and
> it doesn't show any verbose information at all.
> 
> The attached patch presents verbose information but without the AG
> information for realtime files.

Looks ok to me.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
