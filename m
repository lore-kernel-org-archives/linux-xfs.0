Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U8KlAM011664 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 02:20:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47023188B2A0
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 00:20:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2HlgI0vDclHynHcQ for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2009 00:20:07 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LSobf-0003QA-0B
	for xfs@oss.sgi.com; Fri, 30 Jan 2009 08:20:07 +0000
Date: Fri, 30 Jan 2009 03:20:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add missing periods in CHANGES
Message-ID: <20090130082006.GB29564@infradead.org>
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

All the older entries terminate each item with a period, so do it for
the 3.0.0 items, too.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/doc/CHANGES
===================================================================
--- xfsprogs-dev.orig/doc/CHANGES	2009-01-30 09:18:39.807329022 +0100
+++ xfsprogs-dev/doc/CHANGES	2009-01-30 09:19:01.909306360 +0100
@@ -1,15 +1,15 @@
 xfsprogs-3.0.0
-	- Various smaller xfs_repair improvements
-	- Various gettext improvements, thanks to Jakub Bogusz
-	- Polish translation update, thanks to Jakub Bogusz
-	- Various xfs_quota fixes, thanks to Arkadiusz Miskiewicz
-	- Support parallel builds
-	- Detection of btrfs, gfs and gfs2 in libdisk
+	- Various smaller xfs_repair improvements.
+	- Various gettext improvements, thanks to Jakub Bogusz.
+	- Polish translation update, thanks to Jakub Bogusz.
+	- Various xfs_quota fixes, thanks to Arkadiusz Miskiewicz.
+	- Support parallel builds.
+	- Detection of btrfs, gfs and gfs2 in libdisk.
 	- Addition of the xfs_fsr and xfs_estimate tools previous found
-	  in the xfsdump package
-	- Resync libxfs to latest kernel implemenation
-	- Update all of xfsprogs to latest kernel interfaces
-	- Add sparse support to xfsprogs build
+	  in the xfsdump package.
+	- Resync libxfs to latest kernel implemenation.
+	- Update all of xfsprogs to latest kernel interfaces.
+	- Add sparse support to xfsprogs build.
 	- Cleanup devel package for xfsctl, libhandle and libdisk only
 	  (remove libxfs interfaces).
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
