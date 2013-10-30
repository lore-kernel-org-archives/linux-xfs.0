Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B7467F6C
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 090888F8059
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ye54DWjPloBEPVbo for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:30 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002yJ-Ga
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007dP-Fl
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/30 V3] xfsprogs: CRC write support for xfs_db
Date: Wed, 30 Oct 2013 15:30:51 +1100
Message-Id: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This is an update version of the patch series posted here
previously:

http://oss.sgi.com/archives/xfs/2013-09/msg00805.html

Several of the kernel sync patches have been merged, but there a
several more been added (the kernel is a moving target) to bring the
code bases back into sync with the current kernel code.

Otherwise the patch set is mostly unchanged as nobody has made any
comments on the libxfs/xfs_db code changes in the series yet.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
