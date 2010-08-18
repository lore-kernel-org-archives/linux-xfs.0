Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBa31Q110365 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:36:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 583D055A7
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:36:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	KniA7Vaw6a9kCnBh for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:36:32 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	35480604-1927428
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 21:06:31 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OlgwW-0005KZ-Ou
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:28 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OlgwS-0007nn-PG
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: current pending patches
Date: Wed, 18 Aug 2010 21:36:11 +1000
Message-Id: <1282131379-29932-1-git-send-email-david@fromorbit.com>
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

Folks,

This is the current list of patches that I have for the main XFS tree.
Some of the patches have been reviewed, the ones that haven't got reviewed-by
tags have been updated after the last round of review and need another pass.

The patches are also available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git for-oss

Note that this branch is currently based on 2.6.36-rc1, so if you pull from it
and try it you are likely to have a kernel that hangs in the writeback code. I
will rebase it on 2.6.35 once I get everything reviewed and have to update all
the tags.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
