Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAIHL85a188959 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 11:21:09 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201111181721.pAIHL5VU002315@stout.americas.sgi.com>
Date: Fri, 18 Nov 2011 11:21:05 -0600
Subject: [PATCH] MAINTAINERS: update XFS maintainer entry
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
To: xfs@oss.sgi.com
Cc: bpm@sgi.com

I will no longer be maintaining XFS for SGI.  Ben Myers
(bpm@sgi.com) has agreed to be the primary maintainer
for XFS in my place.  I will continue to be able to push
commits to the SGI XFS tree if required.  As such I will
continue to be a designated XFS maintainer, but plan to
serve in more of a backup role.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4808256..227cd7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7425,7 +7425,8 @@ F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
-M:	Alex Elder <aelder@sgi.com>
+M:	Ben Myers <bpm@sgi.com>
+M:	Alex Elder <elder@kernel.org>
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
-- 
1.7.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
