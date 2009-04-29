Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TDnfDv163938 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 08:49:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB28724C912
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:49:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TTkMuh1xTMutOfYi for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:49:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LzAAO-0001bG-GP
	for xfs@oss.sgi.com; Wed, 29 Apr 2009 13:49:40 +0000
Date: Wed, 29 Apr 2009 09:49:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] dmapi: bump version and update CHANGES
Message-ID: <20090429134940.GA30808@infradead.org>
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

Index: dmapi-dev/VERSION
===================================================================
--- dmapi-dev.orig/VERSION	2009-04-29 15:35:03.447607212 +0200
+++ dmapi-dev/VERSION	2009-04-29 15:35:06.731519494 +0200
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=2
-PKG_REVISION=9
+PKG_REVISION=10
 PKG_BUILD=1
Index: dmapi-dev/doc/CHANGES
===================================================================
--- dmapi-dev.orig/doc/CHANGES	2009-04-29 15:35:10.867482929 +0200
+++ dmapi-dev/doc/CHANGES	2009-04-29 15:36:03.542550769 +0200
@@ -1,3 +1,8 @@
+dmapi-2.2.10
+	- Update the Makepkgs script to generate proper source tarballs.
+	- Small specfile improvements, thanks to Jan Engelhardt.
+	- Various autoconf/libtool fixes, thanks to Andreas Gruenbacher.
+
 dmapi-2.2.9 (4 February 2009)
 	- Various build system updates.
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
