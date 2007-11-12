Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 17:58:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC1wFBK012219
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 17:58:18 -0800
Date: Mon, 12 Nov 2007 12:58:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: files getting truncated on xfs
Message-ID: <20071112015810.GX995458@sgi.com>
References: <4736987E.4000208@danbala.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4736987E.4000208@danbala.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dirck Blaskey <listtarget2@danbala.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 10, 2007 at 09:51:58PM -0800, Dirck Blaskey wrote:
> Although there was a truncation bug listed as introduced in 2.6.21 and 
> fixed before 2.6.22,

can you be more specific? i.e. a link to the bug report?

> I had a number of truncations occur with Ubuntu Gutsy Gibbon (kernel 
> 2.6.22) AMD64 build
> using XFS on RAID 1 partition, so apparently it's not fixed.  This 
> looked very much like
> the bug described previously - a number of files truncated to block 
> boundaries on restart.

What is the test case you have that shows this bug?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
