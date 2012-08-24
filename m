Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O0AiZe106431 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 19:10:44 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EBiGSTMWVvYORUNM for <xfs@oss.sgi.com>;
	Thu, 23 Aug 2012 17:11:30 -0700 (PDT)
Date: Fri, 24 Aug 2012 10:11:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 2/4] xfs: Introduce a helper routine to probe data or
	hole offset from page cache
Message-ID: <20120824001128.GY19235@dastard>
References: <503350DD.6030503@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <503350DD.6030503@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 21, 2012 at 05:11:57PM +0800, Jeff Liu wrote:
> Introduce helpers to probe data or hole offset from page cache.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
