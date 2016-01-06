Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 635B47F3F
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 17:32:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA61B304039
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 15:32:33 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	inrExaZLYMC3tpov for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 15:32:30 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aGxY9-0000Ci-Rx
	for xfs@oss.sgi.com; Thu, 07 Jan 2016 10:31:29 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aGxY9-0003d5-Qs
	for xfs@oss.sgi.com; Thu, 07 Jan 2016 10:31:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: small debug improvements
Date: Thu,  7 Jan 2016 10:31:25 +1100
Message-Id: <1452123087-13892-1-git-send-email-david@fromorbit.com>
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

These are a couple of simple patches I have recently been using when
trying to diagnose issues that have been reported to me. They seem
useful enough to include for everyone, so here they are.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
