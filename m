Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9715na083041 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 01:01:05 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eCSRwYsvP4Ok1bCp for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 23:03:01 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWicF-0006Ao-VQ
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 18:02:59 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWicF-0003oB-R1
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 18:02:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: fixes for release candidate.
Date: Fri,  9 Nov 2012 18:02:56 +1100
Message-Id: <1352444578-14600-1-git-send-email-david@fromorbit.com>
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

These are two fixes for bugs that have shown up during the -rc
phase of the release. Please consider them for inclusion.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
