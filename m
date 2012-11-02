Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA20b760064906 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 19:37:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	z1szbjpzKi1g3F0S for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 17:38:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TU5Hb-0004WF-87
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:47 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TU5Hb-0000nB-3H
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: fixes for 3.7-rc3
Date: Fri,  2 Nov 2012 11:38:38 +1100
Message-Id: <1351816724-3000-1-git-send-email-david@fromorbit.com>
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

Hi Ben,

Here are my current outstanding fixes that are candidates for 3.7.
Patches 2 and 3 are the initial fixes from the verifier series (real
bugs) and the other are regressions that I've recently fixed. Some
need to be sent back to stable kernels as well and are tagged as
such.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
