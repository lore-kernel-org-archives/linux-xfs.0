Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBD637F37
	for <xfs@oss.sgi.com>; Sun, 24 May 2015 07:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC3398F8040
	for <xfs@oss.sgi.com>; Sun, 24 May 2015 05:23:14 -0700 (PDT)
Received: from mail-ob0-f178.google.com (mail-ob0-f178.google.com
	[209.85.214.178]) by cuda.sgi.com with ESMTP id
	6cXnB4XYwMUc1BVA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 May 2015 05:23:13 -0700 (PDT)
Received: by obbea2 with SMTP id ea2so39377262obb.3
	for <xfs@oss.sgi.com>; Sun, 24 May 2015 05:23:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 May 2015 14:23:12 +0200
Message-ID: <CA+o=1OXujV+DhfX3fMr9Yyq39JxsoRZo4NNxQpLFjxrc3dcHdQ@mail.gmail.com>
Subject: [PATCH] xfs: fix kernel version in docs
From: Fanael Linithien <fanael4@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Linux v3.20 was released as v4.0.

Signed-off-by: Fanael Linithien <fanael4@gmail.com>
---
 Documentation/filesystems/xfs.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt
b/Documentation/filesystems/xfs.txt
index 5a5a055..8146e9f 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -236,10 +236,10 @@ Removed Mount Options

   Name                Removed
   ----                -------
-  delaylog/nodelaylog        v3.20
-  ihashsize            v3.20
-  irixsgid            v3.20
-  osyncisdsync/osyncisosync    v3.20
+  delaylog/nodelaylog        v4.0
+  ihashsize            v4.0
+  irixsgid            v4.0
+  osyncisdsync/osyncisosync    v4.0


 sysctls
@@ -346,5 +346,5 @@ Removed Sysctls

   Name                Removed
   ----                -------
-  fs.xfs.xfsbufd_centisec    v3.20
-  fs.xfs.age_buffer_centisecs    v3.20
+  fs.xfs.xfsbufd_centisec    v4.0
+  fs.xfs.age_buffer_centisecs    v4.0
-- 
2.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
