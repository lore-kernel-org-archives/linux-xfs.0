Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12204-g5d5e3d5
Message-Id: <20130820221654.C9E197FBA@oss.sgi.com>
Date: Tue, 20 Aug 2013 17:16:54 -0500 (CDT)
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
  5d5e3d5 xfs: Add support for the Q_XGETQSTATV
      from  c2bfbc9b485a750b6af4a97ff3ad22b576e74d20 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 5d5e3d57605e77708685e8d20a40fe86891db299
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Tue Aug 6 17:27:08 2013 -0500

    xfs: Add support for the Q_XGETQSTATV
    
    For XFS, add support for Q_XGETQSTATV quotactl command.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Rich Johnston <rjohnston@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_qm.h          |  2 ++
 fs/xfs/xfs_qm_syscalls.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_quotaops.c    | 13 ++++++++
 3 files changed, 97 insertions(+)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
