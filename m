Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DL8M6l152487 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 16:08:22 -0500
Date: Tue, 13 Oct 2009 16:09:41 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200910132109.n9DL9fh8007576@stout.americas.sgi.com>
Subject: [GIT PULL] XFS bugfix update for 2.6.32
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

The following changes since commit 80f506918fdaaca6b574ba931536a58ce015c7be:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus

Christoph Hellwig (1):
      xfs: fix double IRELE in xfs_dqrele_inode

 fs/xfs/quota/xfs_qm_syscalls.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
