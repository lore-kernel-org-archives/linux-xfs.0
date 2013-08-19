Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DA0D7F8D
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:39:23 -0500 (CDT)
Message-ID: <52126657.8070904@sgi.com>
Date: Mon, 19 Aug 2013 13:39:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/12] xfs: another chunk of comment fixes
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On 08/11/13 22:14, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>
>    Submit another chunk of xfs comment fixes.
>
> Zhi Yong Wu (12):
>    xfs: fix the comment of xfs_bmap_count_tree()
>    xfs: fix the comment of xfs_bmap_validate_ret()
>    xfs: fix the comment of xfs_bmap_last_before()
>    xfs: fix the comment of xfs_bmap_punch_delalloc_range()
>    xfs: fix the comment of xfs_setsize_buftarg_early()
>    xfs: fix the comment of xfs_extent_busy_update_extent()
>    xfs: fix the comment of xfs_ialloc_ag_select()
>    xfs: fix the comment of xfs_ifree_cluster()
>    xfs: fix the comment of xfs_log_unmount_write()
>    xfs: fix the comment of xlog_recover_do_dquot_buffer()
>    xfs: fix the comment of xfs_sb_quiet_read_verify()
>    xfs: fix the comment of xfs_mountfs()

I fixed up the files:
   xfs_inode.c -> xfs_inode_fork.c
   xfs_bmap.c -> xfs_bmap_util.c

The mentioned patch 6/12 in this series.

I will send the changes to Ben

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
