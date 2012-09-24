Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ONcMk3229951 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 18:38:22 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id KUqm8BuhjROJbslS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 16:39:35 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id B0C5C33D6EB
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 23:39:34 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 1/3] rename configure.in to configure.ac
Date: Mon, 24 Sep 2012 19:39:36 -0400
Message-Id: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
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

Newer autotools warn and start to error with the older name.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 configure.in => configure.ac | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename configure.in => configure.ac (100%)

diff --git a/configure.in b/configure.ac
similarity index 100%
rename from configure.in
rename to configure.ac
-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
