Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LGxW3l198277 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 10:59:32 -0600
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id xnpPmE2W7IZ9B8Hl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Feb 2012 08:59:31 -0800 (PST)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 21 Feb 2012 11:59:31 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 124BE38C809B
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:59:07 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1LGx2aU307184 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:59:02 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q1LGwwXM021532 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 14:58:58 -0200
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 10:58:57 -0600
Message-Id: <20120221165857.23253.15762.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120221165833.23253.38042.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [PATCH 4/4] xfstests: Add the new test to the group file
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From 16e62fe191e58cd45130376866b779cad2e56683 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 21 Feb 2012 09:33:39 -0600
Subject: [PATCH 4/4] Add the new test 276 to the group file.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 group |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/group b/group
index 08d999a..f39c303 100644
--- a/group
+++ b/group
@@ -389,3 +389,4 @@ deprecated
 273 auto rw
 274 auto rw
 275 auto rw
+276 quota auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
