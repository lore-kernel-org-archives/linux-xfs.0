Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbeHAWsD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 18:48:03 -0400
Subject: Re: [PATCH] libxfs: fix spdx tag in xfs_cksum.h
References: <20180801205531.GK30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a3d7ea3e-2efa-a341-96b4-50c6a103cdc9@sandeen.net>
Date: Wed, 1 Aug 2018 16:00:24 -0500
MIME-Version: 1.0
In-Reply-To: <20180801205531.GK30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 8/1/18 3:55 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the SPDX tag style to match the kernel.

Sure :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/xfs_cksum.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_cksum.h b/libxfs/xfs_cksum.h
> index b4bf9b4c..999a290c 100644
> --- a/libxfs/xfs_cksum.h
> +++ b/libxfs/xfs_cksum.h
> @@ -1,4 +1,4 @@
> -// SPDX-License-Identifier: GPL-2.0
> +/* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef _XFS_CKSUM_H
>  #define _XFS_CKSUM_H 1
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
