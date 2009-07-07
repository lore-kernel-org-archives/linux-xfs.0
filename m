Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67Ge4Mh155908 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 11:40:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEAAB1B00567
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 09:40:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id j90KOTNS6FkRfsHj for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 09:40:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MODig-0003Hx-Ue
	for xfs@oss.sgi.com; Tue, 07 Jul 2009 16:40:39 +0000
Date: Tue, 7 Jul 2009 12:40:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix trivial typo in test 204 description
Message-ID: <20090707164038.GA9609@infradead.org>
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

Index: xfstests-dev/204
===================================================================
--- xfstests-dev.orig/204	2009-07-04 18:07:47.000000000 +0000
+++ xfstests-dev/204	2009-07-04 18:07:51.000000000 +0000
@@ -1,7 +1,7 @@
 #! /bin/sh
 # FS QA Test No. 204
 #
-# Test out ENOSPC flushiung on small filesystems.
+# Test out ENOSPC flushing on small filesystems.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2009 Christoph Hellwig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
