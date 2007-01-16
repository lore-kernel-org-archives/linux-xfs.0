Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 17:04:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0G145qw022117
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 17:04:07 -0800
Date: Tue, 16 Jan 2007 12:03:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: FW: REVIEW: 031 QA failure with xfs_repair
Message-ID: <20070116010310.GM44411608@melbourne.sgi.com>
References: <200701160045.LAA21869@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701160045.LAA21869@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 16, 2007 at 11:51:06AM +1100, Barry Naujok wrote:
>  
> QA 030 and 031 are failing with xfs_repair as the "zeroed log" is
> different 
> on IRIX and Linux.
> 
> xfs_repair must be coded to handle the different platform log 
> formats.

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
