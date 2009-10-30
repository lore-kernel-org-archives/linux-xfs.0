Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9UIvRfv243172 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 13:57:28 -0500
Date: Fri, 30 Oct 2009 13:57:35 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200910301857.n9UIvZ6w009983@stout.americas.sgi.com>
Subject: [GIT PULL] XFS (2 regression fixes)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Linus, Christoph Hellwig sent a pull request for these patches from
the xfs-dev tree on kernel.org earlier today.  (Pointing this out to
hopefully avoid confusion.)

					-Alex

The following changes since commit 2e2ec952350f25242f2e0539db16b1e46f9eb01b:
  Linus Torvalds (1):
        Merge branch 'bugfix' of git://git.kernel.org/.../jeremy/xen

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (2):
      Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus

Eric Sandeen (1):
      xfs: free temporary cursor in xfs_dialloc

Ryota Yamauchi (1):
      xfs: fix xfs_quota remove error

 fs/xfs/linux-2.6/xfs_quotaops.c |    2 +-
 fs/xfs/xfs_ialloc.c             |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
