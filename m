Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2M5FVCD180389 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 00:15:31 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eAFHgmTrDcKHZeem for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 22:15:29 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAaMt-00035d-RL
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:23 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAaMm-0000WL-C8
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATH 0/8] xfs: outstanding patches for 3.4 merge window
Date: Thu, 22 Mar 2012 16:15:05 +1100
Message-Id: <1332393313-1955-1-git-send-email-david@fromorbit.com>
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

The first 5 patches have been previously posted and reviewed, but not yet
comitted to the XFS repo.

The last three patches are new. The first two fix reported bugs and
are stable kernel backport candidates, and the last is an update to
the attribute event tracing code to add some insight into the
attribute modification paths. This one might be 3.5 material, but it
can't hurt to try.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
