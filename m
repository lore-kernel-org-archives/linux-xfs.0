Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12202-gc2bfbc9
Message-Id: <20130820211533.9BE177FF5@oss.sgi.com>
Date: Tue, 20 Aug 2013 16:15:32 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, master has been updated
  c2bfbc9 xfs: fix the comment of xfs_mountfs()
  2533787 xfs: fix the comment of xfs_sb_quiet_read_verify()
  8ba701e xfs: fix the comment of xlog_recover_do_dquot_buffer()
  8e159e7 xfs: fix the comment of xfs_log_unmount_write()
  0b8182d xfs: fix the comment of xfs_ifree_cluster()
  2f21ff1 xfs: fix the comment of xfs_ialloc_ag_select()
  b3c49634 xfs: fix the comment of xfs_extent_busy_update_extent()
  8b4ad79 xfs: fix the comment of xfs_setsize_buftarg_early()
  ad4809b xfs: fix the comment of xfs_bmap_punch_delalloc_range()
  02bb487 xfs: fix the comment of xfs_bmap_last_before()
  a97f4df xfs: fix the comment of xfs_bmap_validate_ret()
  8be11e9 xfs: fix the comment of xfs_bmap_count_tree()
  c7c1a7d xfs: rename bio_add_buffer() to xfs_bio_add_buffer()
  0a94da2 xfs: fix the comment of xlog_find_head()
  34be5ff xfs: fix the comment of xlog_recover_buffer_pass2()
  5c75390 xfs: remove two unused macro definitions in xfs_linux.h
  1cb9386 xfs: fix the comment of xfs_btree_get_iroot()
  f6c2734 xfs: fix the comment of xfs_iroot_realloc()
  7c3e664 xfs: remove one blank line in xfs_btree_make_block_unfull()
  ac0e300 xfs: fix the comment of xlog_write_setup_copy()
  99e738b xfs: fix the comment of xfs_mod_incore_sb_unlocked()
  49d3da1 xfs: fix the comment of xfs_btree_lookup()
  b46fe82 xfs: fix the comment of xfs_buf_free()
  0471f62 xfs: fix the comment of xfs_check_sizes()
      from  2ad01f53dc34ef3180e555d40b331f95f269a0fa (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c2bfbc9b485a750b6af4a97ff3ad22b576e74d20
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:15:03 2013 +0000

    xfs: fix the comment of xfs_mountfs()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2533787a43b91ec362639ccc11151c8663f121a9
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:15:02 2013 +0000

    xfs: fix the comment of xfs_sb_quiet_read_verify()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8ba701ee9e837d92b5acf93e20b6e88590235f36
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:15:01 2013 +0000

    xfs: fix the comment of xlog_recover_do_dquot_buffer()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8e159e72e283baaccc5a884001cd32cacba70282
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:15:00 2013 +0000

    xfs: fix the comment of xfs_log_unmount_write()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0b8182dba6741a009d4c2ed6f67b30f333ffba7b
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:59 2013 +0000

    xfs: fix the comment of xfs_ifree_cluster()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2f21ff1cca79e1d7805416bac5356508e7e652d5
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:58 2013 +0000

    xfs: fix the comment of xfs_ialloc_ag_select()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b3c496343b98b76957005dfc5eb46eb0ca25c240
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:57 2013 +0000

    xfs: fix the comment of xfs_extent_busy_update_extent()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8b4ad79cc68261cc51acd266df4b8680c1a55588
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:56 2013 +0000

    xfs: fix the comment of xfs_setsize_buftarg_early()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit ad4809bf221bd115ecc38e8a799d2bd74817a6cb
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:55 2013 +0000

    xfs: fix the comment of xfs_bmap_punch_delalloc_range()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 02bb4873db4394d6320aca85996353b4f6ba9ac9
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:54 2013 +0000

    xfs: fix the comment of xfs_bmap_last_before()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a97f4df7b5c0bac497deb6135c9d94810c8f771f
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:53 2013 +0000

    xfs: fix the comment of xfs_bmap_validate_ret()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8be11e92b60b6f333c931d4c855e935d67649e80
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Mon Aug 12 03:14:52 2013 +0000

    xfs: fix the comment of xfs_bmap_count_tree()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit c7c1a7d8bb45479e01ae47a8e8dbf4e769028f07
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:09 2013 +0000

    xfs: rename bio_add_buffer() to xfs_bio_add_buffer()
    
    Follow up with xfs naming style.
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0a94da24b92d965fe13af4f6e4ee2c741e126db9
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:08 2013 +0000

    xfs: fix the comment of xlog_find_head()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 34be5ff37880dd77d83a1f19944ca9667dc963cd
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:07 2013 +0000

    xfs: fix the comment of xlog_recover_buffer_pass2()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5c75390924a402fd1f9194bd69abf54fcc2d446b
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:06 2013 +0000

    xfs: remove two unused macro definitions in xfs_linux.h
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 1cb9386354dbba25301d2aea370af52934f07ea7
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:05 2013 +0000

    xfs: fix the comment of xfs_btree_get_iroot()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f6c27349241f7ecacbc4d883cd79fdddeeff027c
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:04 2013 +0000

    xfs: fix the comment of xfs_iroot_realloc()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 7c3e66405157ee2b56d22c1a21fd0c333d7cf3c1
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:03 2013 +0000

    xfs: remove one blank line in xfs_btree_make_block_unfull()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit ac0e300fa5d36e4c35fdf417473a874b5b6551d0
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:02 2013 +0000

    xfs: fix the comment of xlog_write_setup_copy()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 99e738b7833314d96ab6fd3a8d75da977674e07e
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:01 2013 +0000

    xfs: fix the comment of xfs_mod_incore_sb_unlocked()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 49d3da149c2331c7960fbc6da6bf2cf3a6b06724
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:11:00 2013 +0000

    xfs: fix the comment of xfs_btree_lookup()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b46fe8259ba9a228c27fc4e1eb995377163a6390
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:10:59 2013 +0000

    xfs: fix the comment of xfs_buf_free()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0471f62e386e7c8d9f46ebb35cfbb88f9ca2835f
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Aug 7 10:10:58 2013 +0000

    xfs: fix the comment of xfs_check_sizes()
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c        | 4 ++--
 fs/xfs/xfs_bmap.c        | 6 +++---
 fs/xfs/xfs_bmap_util.c   | 4 ++--
 fs/xfs/xfs_btree.c       | 5 ++---
 fs/xfs/xfs_buf.c         | 4 ++--
 fs/xfs/xfs_extent_busy.c | 2 +-
 fs/xfs/xfs_ialloc.c      | 2 +-
 fs/xfs/xfs_inode.c       | 2 +-
 fs/xfs/xfs_inode_fork.c  | 2 +-
 fs/xfs/xfs_linux.h       | 2 --
 fs/xfs/xfs_log.c         | 4 ++--
 fs/xfs/xfs_log_recover.c | 6 +++---
 fs/xfs/xfs_mount.c       | 6 +++---
 fs/xfs/xfs_sb.c          | 2 +-
 14 files changed, 24 insertions(+), 27 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
