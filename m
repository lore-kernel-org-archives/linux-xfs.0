Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B9B67F54
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 14:42:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B9E78F8037
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 12:42:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id spzZlYuC2riIz5fC for <xfs@oss.sgi.com>;
	Sat, 01 Mar 2014 12:42:42 -0800 (PST)
Message-ID: <53124642.9040805@sandeen.net>
Date: Sat, 01 Mar 2014 14:42:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] man: xfs_repair.8: Fix a grammatical error
References: <1393681600-13098-1-git-send-email-andrew@digital-domain.net>
In-Reply-To: <1393681600-13098-1-git-send-email-andrew@digital-domain.net>
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
To: Andrew Clayton <andrew@digital-domain.net>, xfs@oss.sgi.com

On 3/1/14, 7:46 AM, Andrew Clayton wrote:
> Fix an issue in the -o force_geometry suboption text.
> 
> Signed-off-by: Andrew Clayton <andrew@digital-domain.net>

thanks,

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  man/man8/xfs_repair.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> index ed20fb7..b7c2d8c 100644
> --- a/man/man8/xfs_repair.8
> +++ b/man/man8/xfs_repair.8
> @@ -144,7 +144,7 @@ reduce repair times on concat based filesystems.
>  .BI force_geometry
>  Check the filesystem even if geometry information could not be validated.
>  Geometry information can not be validated if only a single allocation
> -group and exist and thus we do not have a backup superblock available, or
> +group exists and thus we do not have a backup superblock available, or

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
