Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45802 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751885AbdFOXs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 19:48:57 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5FNmuxs028032
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 23:48:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v5FNmudZ009454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 23:48:56 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v5FNmus8018067
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2017 23:48:56 GMT
Date: Thu, 15 Jun 2017 16:48:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: fix mailing list
Message-ID: <20170615234854.GA5421@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Fix the mailing list since it's way out of date.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../xfs_filesystem_structure.asciidoc              |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 5540fa0..4b0a054 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -34,7 +34,7 @@ design goals.
 The information contained in this document derives from the XFS source code in
 the Linux kernel as of v4.3.  This book's source code is available at
 +git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git+.  Feedback should
-be sent to the XFS mailing list, currently at +xfs@oss.sgi.com+.
+be sent to the XFS mailing list, currently at +linux-xfs@vger.kernel.org+.
 
 [NOTE]
 All fields in XFS metadata structures are in big-endian byte order except for
