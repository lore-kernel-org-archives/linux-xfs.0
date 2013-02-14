Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 492FE8048
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 15:25:09 -0600 (CST)
Date: Thu, 14 Feb 2013 15:25:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/9] xfs: take inode version into account in XFS_LITINO
Message-ID: <20130214212505.GH22182@sgi.com>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1358774760-21841-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 22, 2013 at 12:25:52AM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add a version argument to XFS_LITINO so that it can return different values
> depending on the inode version.  This is required for the upcoming v3 inodes
> with a larger fixed layout dinode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
