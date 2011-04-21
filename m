Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L9V8tP149861 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 04:31:08 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED334132E34E
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 02:34:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SPV2KnC5cquV0r7G for <xfs@oss.sgi.com>;
	Thu, 21 Apr 2011 02:34:35 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QCqHG-0003Ud-9A
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 19:34:22 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QCqHO-0003hM-N9
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 19:34:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfs: candidate fixes for 2.6.39-rc4 v2
Date: Thu, 21 Apr 2011 19:34:24 +1000
Message-Id: <1303378468-14163-1-git-send-email-david@fromorbit.com>
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

Candidate bug fix patch stack. Updated to fix minor issues Lachlan
and Christoph noticed in the first version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
