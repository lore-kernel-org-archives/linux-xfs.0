Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3rmBE184589 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:48 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F83B1A2ABA7
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:11 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lHDueKlsdvlGCwEs for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:11 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxh-0008FB-GV
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:55:57 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvE-0004Sz-Jj
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: candidate 2.6.38-rc fixes V3
Date: Thu, 27 Jan 2011 14:53:13 +1100
Message-Id: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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

Fixed the various issues found during review and added all the
reviewed-by tags to the fully reviewed commits.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
