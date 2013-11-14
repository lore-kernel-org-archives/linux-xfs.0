Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A567F7F37
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 00:22:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 901B8304053
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 22:22:33 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yMGGjIV8dJrMCjRi for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 22:22:31 -0800 (PST)
Date: Thu, 14 Nov 2013 17:22:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] update xfs maintainers
Message-ID: <20131114062226.GN6188@dastard>
References: <20131107220208.GY1935@sgi.com> <527C0F64.3010906@sgi.com>
	<527C4B27.6020205@redhat.com> <527CC50D.4060905@redhat.com>
	<20131108180337.GO10553@sgi.com>
	<20131108193424.GA11052@infradead.org>
	<20131108204605.GA1935@sgi.com> <527D4E8D.3000109@redhat.com>
	<20131108220309.GB1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131108220309.GB1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: elder@kernel.org, Mark Tinguely <tinguely@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>

On Fri, Nov 08, 2013 at 04:03:10PM -0600, Ben Myers wrote:
> From: Ben Myers <bpm@sgi.com>
> 
> xfs: update maintainers 
> 
> Add Dave as maintainer of XFS.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/MAINTAINERS
> ===================================================================
> --- a/MAINTAINERS	2013-11-08 15:20:18.935186245 -0600
> +++ b/MAINTAINERS	2013-11-08 15:22:50.685245977 -0600
> @@ -9387,8 +9387,8 @@ F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
>  P:	Silicon Graphics Inc
> +M:	Dave Chinner <dchinner@fromorbit.com>
>  M:	Ben Myers <bpm@sgi.com>
> -M:	Alex Elder <elder@kernel.org>
>  M:	xfs@oss.sgi.com
>  L:	xfs@oss.sgi.com
>  W:	http://oss.sgi.com/projects/xfs

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
