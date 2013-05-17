Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E36977F3F
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 20:12:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21FD8F8052
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 18:11:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mJOjWdbsHBKyLJTZ for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 18:11:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ud9Bn-0007LG-5Z
	for xfs@oss.sgi.com; Fri, 17 May 2013 11:10:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ud9Bn-0002bd-1N
	for xfs@oss.sgi.com; Fri, 17 May 2013 11:10:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: fixes for 3.10-rc2
Date: Fri, 17 May 2013 11:10:24 +1000
Message-Id: <1368753029-9977-1-git-send-email-david@fromorbit.com>
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

The following patches are fixing regressions, data integrity
problems  and lockdep reports. They are all candidates for 3.10-rc2.
Please consider them for 3.10-rc2.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
