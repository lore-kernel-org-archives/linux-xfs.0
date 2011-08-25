Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P7HFK9172866 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 02:17:16 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17BBE192293E
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:17:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PZgAdYTLy9ud8klG for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 00:17:14 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QwUBZ-00049R-Uo
	for xfs@oss.sgi.com; Thu, 25 Aug 2011 17:17:10 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QwUBZ-0002ux-Ig
	for xfs@oss.sgi.com; Thu, 25 Aug 2011 17:17:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: patch queue for Linux 3.2
Date: Thu, 25 Aug 2011 17:17:00 +1000
Message-Id: <1314256626-11136-1-git-send-email-david@fromorbit.com>
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

These are the previously posted and commented on patches to fix the
dio locking serialisation issues, a couple of small optimisations,
and the conversion of the xfsbufd thread to a work queue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
