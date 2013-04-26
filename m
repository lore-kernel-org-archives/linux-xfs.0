Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92EE129DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 21:19:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B2DC304032
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 19:19:44 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aldphjY1xWXpd6eo for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 19:19:35 -0700 (PDT)
Date: Fri, 26 Apr 2013 12:19:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: tracepoints for xfs_iunlink() and
	xfs_iunlink_remove()
Message-ID: <20130426021934.GY30622@dastard>
References: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
	<1366904490-46821-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366904490-46821-2-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 25, 2013 at 11:41:29AM -0400, Brian Foster wrote:
> Add tracepoints for xfs_iunlink() and xfs_iunlink_remove(). These
> tracepoints are useful for debugging inode link (and unlinked list
> issues).
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
