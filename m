Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0IKSFR6156302 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 14:28:16 -0600
Subject: [PATCH] Series short description
From: Ben Myers <bpm@sgi.com>
Date: Tue, 18 Jan 2011 14:31:33 -0600
Message-ID: <20110118203126.5082.51275.stgit@lady3jane.americas.sgi.com>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

The following series implements...

---

Ben Myers (1):
      xfs_bmap_add_extent_delay_real should set br_startblock to nullstartblock


 fs/xfs/xfs_bmap.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

-- 
Signature

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
