Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4B057F37
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 01:21:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B20BD8F8049
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 23:21:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6gu30xblSMc2iVXD for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 23:21:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VFI5D-0001bP-GE
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 16:21:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VFI5D-0008Iv-FV
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 16:21:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: minor cleanups for userspace sanity
Date: Fri, 30 Aug 2013 16:21:19 +1000
Message-Id: <1377843681-31878-1-git-send-email-david@fromorbit.com>
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

These are just a couple of small patches that fix up minor issues to
do with syncing code to userspace. Trivial, no compiled code impact
at all.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
