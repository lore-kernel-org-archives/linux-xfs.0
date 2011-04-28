Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S2GiMu242152 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 21:16:44 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81B7911AD19D
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 19:20:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iS6V3YIZcXiLYvdS for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 19:20:16 -0700 (PDT)
Date: Thu, 28 Apr 2011 12:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: make a few recently-added tests executable
Message-ID: <20110428022014.GP12436@dastard>
References: <2c89ad7f462d6a930703b9d68bc79ea666f6e7cc.1303422538.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2c89ad7f462d6a930703b9d68bc79ea666f6e7cc.1303422538.git.aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 21, 2011 at 04:49:01PM -0500, Alex Elder wrote:
> By convention all of the tests in the xfstests suite have mode 0755.
> A few have recently committed without the execute bit set.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  mode change 100644 => 100755 246
>  mode change 100644 => 100755 247
>  mode change 100644 => 100755 248
>  mode change 100644 => 100755 250
>  mode change 100644 => 100755 251
>  mode change 100644 => 100755 252
> 
> diff --git a/246 b/246
> old mode 100644
> new mode 100755
> diff --git a/247 b/247
> old mode 100644
> new mode 100755
> diff --git a/248 b/248
> old mode 100644
> new mode 100755
> diff --git a/250 b/250
> old mode 100644
> new mode 100755
> diff --git a/251 b/251
> old mode 100644
> new mode 100755
> diff --git a/252 b/252
> old mode 100644
> new mode 100755

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
