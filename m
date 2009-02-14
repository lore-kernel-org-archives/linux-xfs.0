Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1EGdqJA003269 for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 10:39:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A437F1202AD
	for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 08:39:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LWiICiKgm0EGWlrD for
	<xfs@oss.sgi.com>; Sat, 14 Feb 2009 08:39:17 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LYNXx-00059n-5t
	for xfs@oss.sgi.com; Sat, 14 Feb 2009 16:39:17 +0000
Date: Sat, 14 Feb 2009 11:39:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix comment typos in test 201
Message-ID: <20090214163917.GA19813@infradead.org>
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
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/201
===================================================================
--- xfstests-dev.orig/201	2009-02-14 15:06:31.000000000 +0000
+++ xfstests-dev/201	2009-02-14 15:06:42.000000000 +0000
@@ -1,13 +1,13 @@
 #! /bin/sh
 # FS QA Test No. 201
 #
-# Test out the infamout xfs_btree_delrec corruption.
+# Test out the infamous xfs_btree_delrec corruption.
 #
 # Only happens on 32-bit kernels without CONFIG_LBD, but it should be harmless
 # to run this everywhere.
 #
 #-----------------------------------------------------------------------
-# Copyright (c) 2001 Christoph Hellwig.
+# Copyright (c) 2009 Christoph Hellwig.
 #-----------------------------------------------------------------------
 #
 # creator

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
