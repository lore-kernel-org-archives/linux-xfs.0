Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-2-12938-g027f185
Message-Id: <20140220042405.023BD802D@oss.sgi.com>
Date: Wed, 19 Feb 2014 22:24:03 -0600 (CST)
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
  discards  a64b760771e85f54e0921fb05ac48b0585adccec (commit)
  discards  692f68aab2c794ed9bbb05da5c52c906d91885d0 (commit)
  discards  55daffa4198b405c5f595d46b5556be2f650cdd4 (commit)
  027f185 Merge remote-tracking branch 'xfs-async-aio-extend' into for-next
  b678573 Merge branch 'xfs-fixes-for-3.15' into for-next
  5ef11eb xfs: limit superblock corruption errors to actual corruption
  daba542 xfs: skip verification on initial "guess" superblock read
  7a01e70 xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      from  a64b760771e85f54e0921fb05ac48b0585adccec (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 027f185e66eb24e2ea291ff3b93c1e4bd07b85b4
Merge: b678573 9862f62
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Feb 20 15:16:39 2014 +1100

    Merge remote-tracking branch 'xfs-async-aio-extend' into for-next

commit b678573e29749e7fe884c3a8e61c1cf1e1093987
Merge: 5ef11eb 492185e
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Feb 20 15:16:09 2014 +1100

    Merge branch 'xfs-fixes-for-3.15' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_mount.c | 24 ++++++++++++++++--------
 fs/xfs/xfs_sb.c    |  8 +++-----
 2 files changed, 19 insertions(+), 13 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
