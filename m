Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WG061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:14 -0500
Date: Mon, 29 Oct 2012 20:15:59 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 12/25] xfs: add verifier callback to directory read code
Message-ID: <20121030031559.GO30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-13-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 05:34:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr.c       |   23 ++++++++++++-----------
>  fs/xfs/xfs_attr_leaf.c  |   18 +++++++++---------
>  fs/xfs/xfs_da_btree.c   |   44 ++++++++++++++++++++++++++++----------------
>  fs/xfs/xfs_da_btree.h   |    7 ++++---
>  fs/xfs/xfs_dir2_block.c |   23 ++++++++++++-----------
>  fs/xfs/xfs_dir2_leaf.c  |   33 ++++++++++++++++-----------------
>  fs/xfs/xfs_dir2_node.c  |   43 ++++++++++++++++++++-----------------------
>  fs/xfs/xfs_file.c       |    2 +-
>  8 files changed, 102 insertions(+), 91 deletions(-)

More of the same.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
