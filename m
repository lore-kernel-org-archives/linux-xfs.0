Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52JMhrk124378 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 14:22:43 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 997923040CA
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 12:23:00 -0700 (PDT)
From: robert herndon <rherndon@sgi.com>
Subject: [PATCH] Update dmapi's doc/INSTALL to document method/necessity
Date: Tue,  2 Jun 2009 14:23:00 -0500
Message-Id: <1243970580-12580-1-git-send-email-rherndon@attica.americas.sgi.com>
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
Cc: robert herndon <rherndon@elm.eagan>

From: robert herndon <rherndon@elm.eagan>

---
 doc/INSTALL |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/doc/INSTALL b/doc/INSTALL
index ec5a4ef..19493f7 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -12,6 +12,9 @@ library from source, and how to install it.
 
 1. Configure, build and install the package
 
+   Ensure that you have installed the required libraries and
+   header files.  See doc/INSTALL in the xfsprogs repository.
+
    The "dmapi" package uses autoconf/configure and expects a GNU build
    environment (your platform must at least have both autoconf and gmake). 
 
-- 
1.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
