Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33491 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946584AbeCBNaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 08:30:23 -0500
From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] xfs: Change URL for the project in xfs.txt
Date: Fri,  2 Mar 2018 22:30:13 +0900
Message-Id: <20180302133013.9744-1-standby24x7@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>

The oss.sgi.com doesn't exist any more.
Change it to current project URL, https://xfs.wiki.kernel.org/

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/filesystems/xfs.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3b9b5c149f32..4d9ff0a7f8e1 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -9,7 +9,7 @@ variable block sizes, is extent based, and makes extensive use of
 Btrees (directories, extents, free space) to aid both performance
 and scalability.
 
-Refer to the documentation at http://oss.sgi.com/projects/xfs/
+Refer to the documentation at https://xfs.wiki.kernel.org/
 for further details.  This implementation is on-disk compatible
 with the IRIX version of XFS.
 
-- 
2.16.2.345.g7e31236f652a

