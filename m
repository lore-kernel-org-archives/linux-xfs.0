From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.17-rc3-38-gbd438f8
Message-Id: <20140929010135.7497C7FB0@oss.sgi.com>
Date: Sun, 28 Sep 2014 20:01:35 -0500 (CDT)
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

The branch, for-next has been updated
  bd438f8 Merge branch 'xfs-sparse-fixes' into for-next
  b972d07 xfs: annotate user variables passed as void
  e3aed1a xfs: xfs_kset should be static 
  bf1ed38 xfs: xfs_qm_dquot_isolate needs locking annotations for sparse
  e68ed77 xfs: fix use of agi_newino in finobt lookup
      from  2f43bbd96e43d0b85803f5092be94bbb92d8eac9 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit bd438f825f7badafe56d117ed906488c8541f95f
Merge: 2f43bbd b972d07
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Sep 29 10:52:44 2014 +1000

    Merge branch 'xfs-sparse-fixes' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_ialloc.c | 5 ++---
 fs/xfs/xfs_ioctl.c         | 8 ++++----
 fs/xfs/xfs_mount.c         | 3 ---
 fs/xfs/xfs_qm.c            | 1 +
 fs/xfs/xfs_super.c         | 3 ++-
 5 files changed, 9 insertions(+), 11 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
