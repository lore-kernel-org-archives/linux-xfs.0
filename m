Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0FD27FF1
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 17:18:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9242A304059
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 15:18:16 -0800 (PST)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	yYiHHBzbNSR5O9Bp (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 15:18:12 -0800 (PST)
Received: by mail-ie0-f173.google.com with SMTP id u16so2067726iet.18
	for <xfs@oss.sgi.com>; Thu, 07 Nov 2013 15:18:11 -0800 (PST)
Message-ID: <527C1FB5.80305@ieee.org>
Date: Thu, 07 Nov 2013 17:18:13 -0600
From: Alex Elder <elder@ieee.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] update maintainers file
References: <20131107220208.GY1935@sgi.com> <527C0F64.3010906@sgi.com>
	<20131107223250.GM10553@sgi.com>
In-Reply-To: <20131107223250.GM10553@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>
Cc: elder@kernel.org, xfs@oss.sgi.com

On 11/07/2013 04:32 PM, Ben Myers wrote:
> Awhile back Alex reminded me to remove his entry from the MAINTAINERS
> file, as he was my backup.  Now Mark has this role in case I go off my
> meds or something, and Alex will no longer get spammed with XFS patches.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
> [v2: meaningful commit message, as suggested by Eric]
> 
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/MAINTAINERS
> ===================================================================
> --- a/MAINTAINERS	2013-11-07 15:42:04.554561805 -0600
> +++ b/MAINTAINERS	2013-11-07 15:42:59.034889770 -0600
> @@ -9388,7 +9388,7 @@ F:	drivers/xen/*swiotlb*
>  XFS FILESYSTEM
>  P:	Silicon Graphics Inc
>  M:	Ben Myers <bpm@sgi.com>
> -M:	Alex Elder <elder@kernel.org>
> +M:	Mark Tinguely <tinguely@sgi.com>
>  M:	xfs@oss.sgi.com
>  L:	xfs@oss.sgi.com
>  W:	http://oss.sgi.com/projects/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
