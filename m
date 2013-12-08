Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D1B97FD5
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 08:33:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7782AC001
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 06:33:02 -0800 (PST)
Received: from mail-pb0-f50.google.com (mail-pb0-f50.google.com
	[209.85.160.50]) by cuda.sgi.com with ESMTP id zrhOgKxyxOpjb7Oj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:32:59 -0800 (PST)
Received: by mail-pb0-f50.google.com with SMTP id rr13so3789300pbb.23
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:32:58 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] MAINTAINERS: fix incorrect mail address of XFS maintainer
Date: Sun,  8 Dec 2013 23:32:44 +0900
Message-Id: <1386513164-4875-1-git-send-email-linkinjeon@gmail.com>
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
To: dchinner@fromorbit.com, bpm@sgi.com
Cc: Namjae Jeon <namjae.jeon@samsung.com>, Namjae Jeon <linkinjeon@gmail.com>, xfs@oss.sgi.com

From: Namjae Jeon <namjae.jeon@samsung.com>

When I tried to send the patches to XFS Maintainers,
I got returned mail included delivery fail message for Dave's mail.
Maybe, Dave Chinner mail address is incorrect.
I try to fix it correctly.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0f64bd9..3cd17ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9558,7 +9558,7 @@ F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
-M:	Dave Chinner <dchinner@fromorbit.com>
+M:	Dave Chinner <david@fromorbit.com>
 M:	Ben Myers <bpm@sgi.com>
 M:	xfs@oss.sgi.com
 L:	xfs@oss.sgi.com
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
