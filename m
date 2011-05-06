Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p462os1V173114 for <xfs@oss.sgi.com>; Thu, 5 May 2011 21:50:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B24D3C593DE
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 19:54:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lRHjQ5DlEuEvPji8 for <xfs@oss.sgi.com>;
	Thu, 05 May 2011 19:54:33 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QIBBL-00017w-NW
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:19 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QIBBO-0007PK-Fe
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: regression fixes for 2.6.39-rc6
Date: Fri,  6 May 2011 12:54:03 +1000
Message-Id: <1304650448-28438-1-git-send-email-david@fromorbit.com>
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

These are the fixes for recent regressions introduced/exposed
by the recent workqueue conversions. Please review.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
