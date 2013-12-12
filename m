Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 361267F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:05:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 160D38F8033
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:05:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rfJATadgBLmT1PmI for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:05:38 -0800 (PST)
Date: Fri, 13 Dec 2013 09:05:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/8] xfs: get rid of XFS_IALLOC_INODES macros
Message-ID: <20131212220534.GD10988@dastard>
References: <52A967D4.4080903@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A967D4.4080903@oracle.com>
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

On Thu, Dec 12, 2013 at 03:37:56PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Get rid of XFS_IALLOC_INODES() marcos, use mp->m_ialloc_inos directly.
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
