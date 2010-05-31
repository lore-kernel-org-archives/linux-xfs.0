Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6WI5178886 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAFD1387865
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:08:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Lq5GHzqCswge8UVC for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:08:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xv-0000ov-3s
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:08:59 +0000
Message-Id: <20100531160858.981686872@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/17] xfs: remove done roadmap item from
	xfs-delayed-logging-design.txt
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-roadmap-item
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/Documentation/filesystems/xfs-delayed-logging-design.txt
===================================================================
--- xfs.orig/Documentation/filesystems/xfs-delayed-logging-design.txt	2010-05-30 12:23:13.223254240 +0200
+++ xfs/Documentation/filesystems/xfs-delayed-logging-design.txt	2010-05-30 12:23:57.363005673 +0200
@@ -794,11 +794,6 @@ designed.
 
 Roadmap:
 
-2.6.35 Inclusion in mainline as an experimental mount option
-	=> approximately 2-3 months to merge window
-	=> needs to be in xfs-dev tree in 4-6 weeks
-	=> code is nearing readiness for review
-
 2.6.37 Remove experimental tag from mount option
 	=> should be roughly 6 months after initial merge
 	=> enough time to:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
