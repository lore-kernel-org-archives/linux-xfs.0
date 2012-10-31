Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VJNvqT231026 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 14:23:57 -0500
Message-Id: <20121031192545.662795881@sgi.com>
Date: Wed, 31 Oct 2012 14:25:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 1/4] xfstests: update version and changelog
References: <20121031192521.163830089@sgi.com>
Content-Disposition: inline; filename=xfstests-update-version
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

Update the version and changelog for xfstests.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 VERSION      |    2 +-
 configure.ac |    2 +-
 doc/CHANGES  |    4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2012-10-31 13:44:44.931946786 -0500
+++ b/VERSION	2012-10-31 13:44:50.832006406 -0500
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=1
 PKG_MINOR=1
-PKG_REVISION=0
+PKG_REVISION=1
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2012-10-31 13:45:41.661946816 -0500
+++ b/configure.ac	2012-10-31 13:45:48.072005921 -0500
@@ -1,4 +1,4 @@
-AC_INIT([xfstests], [1.1.0])
+AC_INIT([xfstests], [1.1.1])
 AC_PREREQ(2.50)
 AC_CONFIG_SRCDIR([src/xfsctl.c])
 AC_PACKAGE_GLOBALS(xfstests)
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2012-10-31 13:45:16.061322021 -0500
+++ b/doc/CHANGES	2012-10-31 13:48:08.912026611 -0500
@@ -1,3 +1,7 @@
+xfstests-1.1.1 (31 October 2012)
+	- Many bugfixes for existing tests.
+	- Tests 264-289 have been added to the suite.
+
 xfstests-1.1.0 (14 October 2011)
 	- This is the firsteversioned release recorded for the
 	  xfstests suite.  Tests 240-263 have been added to the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
