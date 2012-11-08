Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8A38SL236628 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 04:03:09 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	whBh9aO4KbJuXJTQ for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 02:05:06 -0800 (PST)
Date: Thu, 8 Nov 2012 21:05:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix comments at xfs_growfs_data_private(),
	s/freelist/freespace/
Message-ID: <20121108100502.GN6434@dastard>
References: <509B7AC9.9080906@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509B7AC9.9080906@oracle.com>
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

On Thu, Nov 08, 2012 at 05:26:33PM +0800, Jeff Liu wrote:
> Hello,
> 
> Growfs is trying to write a affected AGF header rather than AGFL, fix it IIUC.
> 
> Thanks,
> -Jeff
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

I'll roll this into the patches I posted a few hours ago that touch
this code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
