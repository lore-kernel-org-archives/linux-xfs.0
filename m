Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61C697F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:10:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0752AC004
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:10:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GmWDXYCYgbjhu8KV for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:10:43 -0800 (PST)
Date: Fri, 13 Dec 2013 09:10:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 4/8] xfs: introduce a common helper
	xfs_icluster_size_fsb
Message-ID: <20131212221042.GG10988@dastard>
References: <52A967F5.6030005@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A967F5.6030005@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Dec 12, 2013 at 03:38:29PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce a common routine xfs_icluster_size_fsb() to calculate
> and return the number of file system blocks per inode cluster.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Easy one. ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
