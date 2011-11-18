Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAIKkBOh203878 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 14:46:11 -0600
Date: Fri, 18 Nov 2011 14:46:27 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [GIT PULL] XFS update for 3.2-rc3
Message-ID: <20111118204627.GQ749@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Linus, please pull the following changes for XFS for 3.2-rc3.  

One is a bugfix for a regression related to quotas, and the other adds
me to the MAINTAINERS list for XFS.

Thanks much!
-Ben

The following changes since commit b6844523839779030430ff28f036f83e2a3f43e6:
  Linus Torvalds (1):
        Merge branch 'stable/for-linus-fixes-3.2' of git://git.kernel.org/.../konrad/xen

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      MAINTAINERS: update XFS maintainer entry

Mitsuo Hayasaka (1):
      xfs: use doalloc flag in xfs_qm_dqattach_one()

 MAINTAINERS     |    3 ++-
 fs/xfs/xfs_qm.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
