Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79NFaeN237650 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 18:15:36 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bA9sGmATe6Cui7nu for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 16:15:34 -0700 (PDT)
Date: Fri, 10 Aug 2012 09:15:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 1/4] xfs: Remove type argument from
	xfs_seek_data()/xfs_seek_hole()
Message-ID: <20120809231530.GZ2877@dastard>
References: <501B6B62.7040303@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501B6B62.7040303@oracle.com>
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

On Fri, Aug 03, 2012 at 02:10:42PM +0800, Jeff Liu wrote:
> The type is already indicated by the function naming explicitly, so this argument
> can be omitted from those calls.
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
