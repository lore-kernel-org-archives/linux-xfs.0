Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 24A867F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 052FB304043
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 17:59:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TBXRAVNsch7eKZz2 for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 17:59:34 -0700 (PDT)
Date: Wed, 26 Jun 2013 10:59:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: .gitignore: add fsync-tester
Message-ID: <20130626005906.GZ29376@dastard>
References: <20130625153435.7a4eb981@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130625153435.7a4eb981@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 25, 2013 at 03:34:35PM -0400, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 0bd48c3..5aa68c3 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -47,6 +47,7 @@
>  /src/fs_perms
>  /src/fstest
>  /src/ftrunc
> +/src/fsync-tester
>  /src/genhashnames
>  /src/getdevicesize
>  /src/getpagesize
> -- 
> 1.8.1.4

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
