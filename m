Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LLjcBf178378 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 16:45:38 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH] xfstests: make a few recently-added tests executable
Date: Thu, 21 Apr 2011 16:49:01 -0500
Message-Id: <2c89ad7f462d6a930703b9d68bc79ea666f6e7cc.1303422538.git.aelder@sgi.com>
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
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

By convention all of the tests in the xfstests suite have mode 0755.
A few have recently committed without the execute bit set.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 246
 mode change 100644 => 100755 247
 mode change 100644 => 100755 248
 mode change 100644 => 100755 250
 mode change 100644 => 100755 251
 mode change 100644 => 100755 252

diff --git a/246 b/246
old mode 100644
new mode 100755
diff --git a/247 b/247
old mode 100644
new mode 100755
diff --git a/248 b/248
old mode 100644
new mode 100755
diff --git a/250 b/250
old mode 100644
new mode 100755
diff --git a/251 b/251
old mode 100644
new mode 100755
diff --git a/252 b/252
old mode 100644
new mode 100755
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
