Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VJNwPG231041 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 14:23:58 -0500
Message-Id: <20121031192546.265330657@sgi.com>
Date: Wed, 31 Oct 2012 14:25:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 4/4] dmapi: update version and changelog
References: <20121031192521.163830089@sgi.com>
Content-Disposition: inline; filename=dmapi-update-version
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
Cc: Nathan Scott <nathans@debian.org>

Update the version and changelog for dmapi.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 VERSION      |    2 +-
 configure.ac |    2 +-
 doc/CHANGES  |    4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2012-10-31 13:42:58.481323425 -0500
+++ b/VERSION	2012-10-31 13:43:04.282005911 -0500
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=2
-PKG_REVISION=10
+PKG_REVISION=11
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2012-10-31 12:27:15.701360575 -0500
+++ b/configure.ac	2012-10-31 12:27:25.491380911 -0500
@@ -1,4 +1,4 @@
-AC_INIT([dmapi], [2.2.10])
+AC_INIT([dmapi], [2.2.11])
 
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2012-10-31 12:28:12.701946439 -0500
+++ b/doc/CHANGES	2012-10-31 12:34:56.581401487 -0500
@@ -1,3 +1,7 @@
+dmapi-2.2.11 (31 Oct 2012)
+	- Various build related fixes, thanks to Theodore Ts'o,
+	  Mike Frysinger, and Jan Engelhardt
+
 dmapi-2.2.10 (5 May 2009)
 	- Update the Makepkgs script to generate proper source tarballs.
 	- Small specfile improvements, thanks to Jan Engelhardt.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
