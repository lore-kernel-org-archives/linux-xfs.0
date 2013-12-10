Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A86D7F9C
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 15:02:17 -0600 (CST)
Date: Tue, 10 Dec 2013 15:02:13 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] MAINTAINERS: fix incorrect mail address of XFS maintainer
Message-ID: <20131210210213.GE1935@sgi.com>
References: <1386513230-4914-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386513230-4914-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com

On Sun, Dec 08, 2013 at 11:33:50PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> When I tried to send the patches to XFS Maintainers,
> I got returned mail included delivery fail message for Dave's mail.
> Maybe, Dave Chinner mail address is incorrect.
> I try to fix it correctly.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0f64bd9..3cd17ec 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9558,7 +9558,7 @@ F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
>  P:	Silicon Graphics Inc
> -M:	Dave Chinner <dchinner@fromorbit.com>
> +M:	Dave Chinner <david@fromorbit.com>

Looks to be correct.  david@fromorbit.com

Reviewed-by: Ben Myers <bpm@sgi.com>

>  M:	Ben Myers <bpm@sgi.com>
>  M:	xfs@oss.sgi.com
>  L:	xfs@oss.sgi.com
> -- 
> 1.7.9.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
