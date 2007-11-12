Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 22:24:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC6Nq7J014592
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 22:23:57 -0800
Date: Mon, 12 Nov 2007 17:23:48 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [[PATCH, RESEND]] Default to log version 2
Message-ID: <20071112062348.GY66820511@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com> <1194839329-22003-1-git-send-email-xaiki@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194839329-22003-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xaiki@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2007 at 02:48:44PM +1100, xaiki@sgi.com wrote:
> From: Niv Sardi <xaiki@sgi.com>
> 

Description?

> ---
>  xfsprogs/mkfs/xfs_mkfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
> index 6e84a4e..5f3299d 100644
> --- a/xfsprogs/mkfs/xfs_mkfs.c
> +++ b/xfsprogs/mkfs/xfs_mkfs.c
> @@ -686,7 +686,7 @@ main(
>  	ilflag = imflag = ipflag = isflag = 0;
>  	liflag = laflag = lsflag = ldflag = lvflag = 0;
>  	loginternal = 1;
> -	logversion = 1;
> +	logversion = 2;
>  	logagno = logblocks = rtblocks = rtextblocks = 0;
>  	Nflag = nlflag = nsflag = nvflag = 0;
>  	dirblocklog = dirblocksize = dirversion = 0;

ok.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
