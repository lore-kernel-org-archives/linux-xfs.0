Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3R0odrX117464 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 19:50:39 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004270052.o3R0qZB7014331@stout.americas.sgi.com>
Date: Mon, 26 Apr 2010 19:52:34 -0500
Subject: [GIT PULL] XFS update for 2.6.34-rc6
MIME-Version: 1.0
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

Sorry to send this so late in the cycle.  It corrects a data
corruption error though and I hate to see it wait until 2.6.35.
If it doesn't make it for -rc6 perhaps you'll take it for -rc7.

					-Alex

The following changes since commit b91ce4d14a21fc04d165be30319541e0f9204f15:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: more swap extent fixes for dynamic fork offsets

 fs/xfs/xfs_dfrag.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
