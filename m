Return-Path: <xfs-bounces@oss.sgi.com>
Received: from penguin4.americas.sgi.com (penguin4.americas.sgi.com
	[128.162.240.140])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RKuApq073206 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 14:56:11 -0600
Date: Tue, 27 Jan 2009 14:55:27 -0600
From: Felix Blyakher <felixb@penguin4.americas.sgi.com>
Message-Id: <200901272055.n0RKtRrI007583@penguin4.americas.sgi.com>
Subject: [GIT PULL] XFS update for 2.6.29-rc3
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

The following changes since commit 5ee810072175042775e39bdd3eaaa68884c27805:
  Linus Torvalds (1):
        Fix "multiple definition of `debugfs_create_size_t'"

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Eric Sandeen (1):
      don't reallocate sxp variable passed into xfs_swapext

 fs/xfs/xfs_dfrag.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
