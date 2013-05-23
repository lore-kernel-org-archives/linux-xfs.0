Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D42367F3F
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 07:36:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C29BAC00D
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 05:36:10 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	h5qiHMIyqhmWoDZb for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 05:36:08 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UfUkZ-0007Z4-66
	for xfs@oss.sgi.com; Thu, 23 May 2013 22:36:07 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UfUkZ-0001du-10
	for xfs@oss.sgi.com; Thu, 23 May 2013 22:36:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: yet more CRC support patches
Date: Thu, 23 May 2013 22:36:03 +1000
Message-Id: <1369312565-6266-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1369032783-24973-1-git-send-email-david@fromorbit.com>
References: <1369032783-24973-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Just a couple for xfs_db - dquot and attribute structure printing.
These go on top of the previous two patches that this one is
threaded to.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
