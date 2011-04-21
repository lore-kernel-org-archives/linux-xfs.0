Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L4PkdM132868 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 23:25:46 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5B543FE523
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:29:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gfWjX1nOYYkGBeam for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2011 21:29:12 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QClVu-00030r-AU
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 14:29:10 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QClVs-0002m7-UZ
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 14:29:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: candidate fixes for 2.6.39-rc4
Date: Thu, 21 Apr 2011 14:29:00 +1000
Message-Id: <1303360144-10632-1-git-send-email-david@fromorbit.com>
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

This is my current bug fix stack. They are probably all candidates
for 2.6.39, though I don't mind if we put any of them off
until.40...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
