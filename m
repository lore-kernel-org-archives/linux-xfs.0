Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E08147F4E
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 01:34:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E09CAC00B
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 23:34:29 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LxOJAoBWOjAHAH7A for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 23:34:27 -0800 (PST)
Date: Tue, 11 Feb 2014 18:34:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 10/11] xfs: report finobt status in fs geometry
Message-ID: <20140211073423.GJ13647@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391536182-9048-11-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 12:49:41PM -0500, Brian Foster wrote:
> Define the XFS_FSOP_GEOM_FLAGS_FINOBT fs geometry flag and set the
> associated bit if the filesystem supports the free inode btree.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
