Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n49LhtA7115062 for <xfs@oss.sgi.com>; Sat, 9 May 2009 16:43:56 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AC33AC002
	for <xfs@oss.sgi.com>; Sat,  9 May 2009 14:43:58 -0700 (PDT)
Message-Id: <FB9BA319-BCAD-450F-BF01-D9F676740F0A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A050993.1020208@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfstests: tidy up 205
Date: Sat, 9 May 2009 16:43:56 -0500
References: <4A050993.1020208@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On May 8, 2009, at 11:41 PM, Eric Sandeen wrote:

> Test 205 wasn't marked executable, and had the wrong test
> number in the comments.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> diff --git a/205 b/205
> old mode 100644
> new mode 100755
> index 2a0b94e..1604cb3
> --- a/205
> +++ b/205
> @@ -1,5 +1,5 @@
> #! /bin/sh
> -# FS QA Test No. 203
> +# FS QA Test No. 205
> #
> # Test out ENOSPC flushiung on small filesystems.
> #
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
