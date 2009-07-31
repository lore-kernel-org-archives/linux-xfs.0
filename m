Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6V5xUjb133952 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 00:59:31 -0500
Date: Fri, 31 Jul 2009 01:00:15 -0500
Subject: [GIT PULL] XFS update for 2.6.31-rc5
MIME-Version: 1.0
Message-Id: <20090731060015.45A8FA23CA6C@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The following changes since commit b592972493c38665efd7d429a01b23fcb21e331a:
  Linus Torvalds (1):
        Merge branch 'tracing-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Eric Sandeen (2):
      xfs: reduce bmv_count in xfs_vn_fiemap
      xfs: bump up nr_to_write in xfs_vm_writepage

 fs/xfs/linux-2.6/xfs_aops.c |    8 ++++++++
 fs/xfs/linux-2.6/xfs_iops.c |    4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
