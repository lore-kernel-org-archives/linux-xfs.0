Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 063CD7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 17:30:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8871304077
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 15:30:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fZ1OgxEP3y3jsioK for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 15:29:57 -0800 (PST)
Date: Thu, 12 Dec 2013 10:29:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: use xfs_ialloc_blks_per_cluster in
	xfs_ialloc_inode_init
Message-ID: <20131211232942.GP10988@dastard>
References: <52A86D24.8030801@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A86D24.8030801@oracle.com>
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

On Wed, Dec 11, 2013 at 09:48:20PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Use xfs_ialloc_blks_per_cluster() in xfs_ialloc_inode_init()
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
