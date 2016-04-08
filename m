Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 058A27CAF
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:51:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB82C8F8054
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 13:51:09 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id vhdfXWiiF7JTqCCr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 13:51:08 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id B76B8340BA2
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 20:51:07 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH xfsdump] configure: add mailing list contact
Date: Fri,  8 Apr 2016 16:51:06 -0400
Message-Id: <1460148666-23271-1-git-send-email-vapier@gentoo.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 7bb6f1d..39aaf25 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT([xfsdump], [3.1.6])
+AC_INIT([xfsdump], [3.1.6], [xfs@oss.sgi.com])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
