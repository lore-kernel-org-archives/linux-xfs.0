Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1945952AbeCBRYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 12:24:06 -0500
Date: Fri, 2 Mar 2018 09:24:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Change URL for the project in xfs.txt
Message-ID: <20180302172401.GT19312@magnolia>
References: <20180302133013.9744-1-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302133013.9744-1-standby24x7@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org

On Fri, Mar 02, 2018 at 10:30:13PM +0900, Masanari Iida wrote:
> The oss.sgi.com doesn't exist any more.
> Change it to current project URL, https://xfs.wiki.kernel.org/
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/filesystems/xfs.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 3b9b5c149f32..4d9ff0a7f8e1 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -9,7 +9,7 @@ variable block sizes, is extent based, and makes extensive use of
>  Btrees (directories, extents, free space) to aid both performance
>  and scalability.
>  
> -Refer to the documentation at http://oss.sgi.com/projects/xfs/
> +Refer to the documentation at https://xfs.wiki.kernel.org/
>  for further details.  This implementation is on-disk compatible
>  with the IRIX version of XFS.

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
> -- 
> 2.16.2.345.g7e31236f652a
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
