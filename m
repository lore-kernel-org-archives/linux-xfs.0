Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9611dqk153360 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 20:01:39 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79A16144A3FD
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 18:08:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LloB3Eodsyo44uj4 for <xfs@oss.sgi.com>;
	Wed, 05 Oct 2011 18:08:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RBcL8-0003AT-Ho
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 12:01:34 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RBcL8-0000nb-8q
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 12:01:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] repair: couple of bug fixes
Date: Thu,  6 Oct 2011 12:01:29 +1100
Message-Id: <1317862891-3033-1-git-send-email-david@fromorbit.com>
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

Hi Alex,

These are a couple of bug fixes to repair that I posted a while ago
that we should probably include in the 3.1.6 release. I don't recall
if they were fully reviewed back when I posted them, so I'm just
sending them again.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
