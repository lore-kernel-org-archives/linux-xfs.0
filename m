Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-2-12941-gf137806
Message-Id: <20140224005350.0EAB47F5A@oss.sgi.com>
Date: Sun, 23 Feb 2014 18:53:48 -0600 (CST)
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
  f137806 Merge branch 'xfs-collapse-range' into for-next
  e1d8fb8 xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
      from  027f185e66eb24e2ea291ff3b93c1e4bd07b85b4 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit f13780692e659df3623461ca5398b66739a6c56f
Merge: 027f185 e1d8fb8
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Feb 24 10:58:55 2014 +1100

    Merge branch 'xfs-collapse-range' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap.c      | 193 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h      |  15 ++++
 fs/xfs/xfs_bmap_util.c |  97 ++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_util.h |   2 +
 fs/xfs/xfs_file.c      |  19 ++++-
 fs/xfs/xfs_trace.h     |   1 +
 6 files changed, 324 insertions(+), 3 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
