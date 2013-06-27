Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7226D7F72
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 01:05:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 415248F804B
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 23:05:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MLTWNHsYCWhzYmHm for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 23:05:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Us5KH-0008Gk-Dm
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Us5KH-00027h-9a
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/15] xfs: patchset for 3.11
Date: Thu, 27 Jun 2013 16:04:44 +1000
Message-Id: <1372313099-8121-1-git-send-email-david@fromorbit.com>
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

Hi Ben,

Here's the current set of patches I have for 3.11. There are 2 new
patches here - the dquot transaction reservation fix, and a simple
one to implement the change count functionality on CRC enabled
filesystems.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
