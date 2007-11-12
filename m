Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 22:24:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC6OP1d014663
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 22:24:29 -0800
Date: Mon, 12 Nov 2007 17:24:23 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [[PATCH, RESEND]] Default to version 2 attributes.
Message-ID: <20071112062423.GZ66820511@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com> <1194839329-22003-1-git-send-email-xaiki@sgi.com> <1194839329-22003-2-git-send-email-xaiki@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194839329-22003-2-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xaiki@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2007 at 02:48:45PM +1100, xaiki@sgi.com wrote:
> From: Niv Sardi <xaiki@sgi.com>
> 

Description?

> ---
>  xfsprogs/mkfs/xfs_mkfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
> index 5f3299d..b378800 100644
> --- a/xfsprogs/mkfs/xfs_mkfs.c
> +++ b/xfsprogs/mkfs/xfs_mkfs.c
> @@ -677,7 +677,7 @@ main(
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  
> -	attrversion = 0;
> +	attrversion = 2;
>  	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
>  	blocklog = blocksize = 0;
>  	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;

ok.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
