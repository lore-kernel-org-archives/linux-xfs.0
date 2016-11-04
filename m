Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42288 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932299AbcKDTDe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Nov 2016 15:03:34 -0400
Subject: Re: [PATCH 3/6] libxfs: fix whitespace problems
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828431586.31793.17971269788876366196.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <84f632e5-f61e-2f53-7b0d-ee79a4dfd77f@sandeen.net>
Date: Fri, 4 Nov 2016 14:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <147828431586.31793.17971269788876366196.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

On 11/4/16 1:31 PM, Darrick J. Wong wrote:
> Fix some whitespace problems that trip up my libxfs-diff script.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ooh ooh I got this one!  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index e2e1106..ea45584 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1016,4 +1016,3 @@ xfs_rtfree_extent(
>  	}
>  	return 0;
>  }
> -
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
