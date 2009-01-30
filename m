Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U8G2Rm010992 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 02:16:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E9BA188AF0C
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 00:15:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id g53QZFNGb7sx6lCY for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2009 00:15:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LSoX3-0002TI-9e
	for xfs@oss.sgi.com; Fri, 30 Jan 2009 08:15:21 +0000
Date: Fri, 30 Jan 2009 03:15:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] dmapi: bump version and update CHANGES
Message-ID: <20090130081521.GA5347@infradead.org>
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

Index: dmapi-dev/doc/CHANGES
===================================================================
--- dmapi-dev.orig/doc/CHANGES	2009-01-24 19:22:05.421554039 +0100
+++ dmapi-dev/doc/CHANGES	2009-01-30 09:14:04.350423953 +0100
@@ -1,3 +1,6 @@
+dmapi-2.2.9
+	- Various build system updates.
+
 dmapi-2.2.8 (9 February 2007)
 	- Fix a problem in get_mnt() called by dm_handle_to_path()
 	  The "dmi" mount option was not considered.
Index: dmapi-dev/VERSION
===================================================================
--- dmapi-dev.orig/VERSION	2009-01-30 09:13:33.524328761 +0100
+++ dmapi-dev/VERSION	2009-01-30 09:13:36.758298882 +0100
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=2
-PKG_REVISION=8
+PKG_REVISION=9
 PKG_BUILD=1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
