Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 035957F56
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 17:18:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7B69304064
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:18:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	H2xpeamNNs3SNfFp for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 15:18:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VVqSm-0004wg-3L
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VVqSm-0005iS-28
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/19 V2] xfs: patches for 3.13
Date: Tue, 15 Oct 2013 09:17:46 +1100
Message-Id: <1381789085-21923-1-git-send-email-david@fromorbit.com>
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

This is an update of the previous patches I sent here:

http://oss.sgi.com/pipermail/xfs/2013-September/030390.html
http://oss.sgi.com/pipermail/xfs/2013-September/030398.html

I've addressed the review comments from Eric, Ben and Christoph
and fixed the non-debug build failure that Michael Semon reported.
Comments and testing welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
