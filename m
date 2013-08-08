Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4D997F7B
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 16:16:17 -0500 (CDT)
Date: Thu, 8 Aug 2013 16:16:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 04/14] xfsprogs: fix gpl headers in xfs_symlink
Message-ID: <20130808211617.GR3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

Just a reminder to make sure this is done, as I think it may be in the 2nd
series.

---
 include/xfs_symlink.h |    1 +
 libxfs/xfs_symlink.c  |    1 +
 2 files changed, 2 insertions(+)

Index: b/include/xfs_symlink.h
===================================================================
--- a/include/xfs_symlink.h	2013-08-06 11:35:20.780818113 -0500
+++ b/include/xfs_symlink.h	2013-08-06 11:35:33.250877623 -0500
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
+ * XXX fix gpl header 
  */
 #ifndef __XFS_SYMLINK_H
 #define __XFS_SYMLINK_H 1
Index: b/libxfs/xfs_symlink.c
===================================================================
--- a/libxfs/xfs_symlink.c	2013-08-06 11:34:22.690818407 -0500
+++ b/libxfs/xfs_symlink.c	2013-08-06 11:34:41.220857196 -0500
@@ -1,6 +1,7 @@
 /*
  * Copyright 2013 Red Hat, Inc.
  * All rights reserved.
+ * XXX gpl header needs to be fixed
  */
 
 #include "xfs.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
