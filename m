Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACB667F5E
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 11:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BFD2304087
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 09:23:45 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id WhixNGgiUq0mCCR3 for
	<xfs@oss.sgi.com>; Tue, 02 Jul 2013 09:23:43 -0700 (PDT)
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Date: Tue,  2 Jul 2013 17:00:47 +0200
Message-Id: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
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
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Cc: Yann Droneaud <ydroneaud@opteya.com>

This patch changes type of xfs@oss.sgi.com

The output of ./scripts/get_maintainer.pl is
modified to report xfs@oss.sgi.com as a list:

 Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
 Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
-xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
+xfs@oss.sgi.com (open list:XFS FILESYSTEM)
 linux-kernel@vger.kernel.org (open list)

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ad7e322..7b6ab51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9139,7 +9139,6 @@ XFS FILESYSTEM
 P:	Silicon Graphics Inc
 M:	Ben Myers <bpm@sgi.com>
 M:	Alex Elder <elder@kernel.org>
-M:	xfs@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com/xfs/xfs.git
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
