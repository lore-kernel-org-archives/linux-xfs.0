Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE6047FEE
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D953AC007
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5eF4zuZzP2Wcffjr for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCZ-0001TU-Bd
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCZ-0005hW-1B
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/13] xfstests: generic --large-fs support
Date: Fri, 15 Mar 2013 22:53:18 +1100
Message-Id: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

This is a repost of my current version of the large filesystem
testing support for xfstests. I've been using it for more than a
year, and I think the ext4 guys would like to have it available to
them.

Last posted here:

http://oss.sgi.com/archives/xfs/2012-07/msg00361.html

There are changes from last time, but it's months since i've made
them, so there's no fine grained changelog. :/

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
