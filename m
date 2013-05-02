Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F6EB7F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 20:13:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ED5F8F8050
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 18:13:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Cjei1Fpisphzu0iX for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 18:13:54 -0700 (PDT)
Date: Thu, 2 May 2013 11:13:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove xfs_krash from struct xfs_mount
Message-ID: <20130502011353.GT10481@dastard>
References: <51812614.2010807@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51812614.2010807@oracle.com>
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

On Wed, May 01, 2013 at 10:26:28PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Remove struct xfs_krash from xfs_mount as there is no user of it nowadays.
                xfs_chash

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
