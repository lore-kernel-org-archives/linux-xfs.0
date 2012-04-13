Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCBABK037764 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:10 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gFwVWauv4Vd1T2Zc for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLI-00031B-T1
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:08 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLD-0003Nt-P7
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/18] xfs: current patch queue
Date: Fri, 13 Apr 2012 22:10:43 +1000
Message-Id: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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

Here's a repost of my current patch queue. They are all based on Christoph's
ilock and xfsbufd patch series and been tested on top of them. I've updated all
the reviewed-by tags, so if the patch is missing such a tag then it hasn't been
reviewed....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
