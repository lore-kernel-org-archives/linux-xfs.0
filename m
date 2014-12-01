From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.18-rc2-28-gc14fc01
Message-Id: <20141201003044.CFC057F5A@oss.sgi.com>
Date: Sun, 30 Nov 2014 18:30:44 -0600 (CST)
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
  c14fc01 Merge branch 'xfs-coccinelle-cleanups' into for-next
  d254aae xfs: fix simple_return.cocci warning in xfs_bmse_shift_one
  8300475 xfs: fix simple_return.cocci warning in xfs_file_readdir
  b72091f libxfs: fix simple_return.cocci warnings
  d2a5e3c xfs: remove unnecessary null checks
      from  216875a594e0b4fc72830e3690b8fbe7430738e2 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c14fc01340dd0afe58d8671acc3ea5e907e707ae
Merge: 216875a d254aae
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Dec 1 09:03:02 2014 +1100

    Merge branch 'xfs-coccinelle-cleanups' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_bmap.c   |  6 +-----
 fs/xfs/libxfs/xfs_ialloc.c |  6 +-----
 fs/xfs/xfs_file.c          |  6 +-----
 fs/xfs/xfs_qm.c            | 12 +++++-------
 fs/xfs/xfs_super.c         |  3 +--
 5 files changed, 9 insertions(+), 24 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
