Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JJKI2S124265 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 13:20:18 -0600
Date: Thu, 19 Feb 2009 13:19:42 -0600
Subject: [GIT PULL] XFS update for 2.6.29-rc6
MIME-Version: 1.0
Message-Id: <20090219191942.EF635144A392D@attica.americas.sgi.com>
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

The following changes since commit 402a917aca5daca69fcc91f43e6f1e6939cf393b:
  Linus Torvalds (1):
        Merge master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Felix Blyakher (2):
      Revert "[XFS] use scalable vmap API"
      Revert "[XFS] remove old vmap cache"

 fs/xfs/linux-2.6/xfs_buf.c |   79 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 76 insertions(+), 3 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
