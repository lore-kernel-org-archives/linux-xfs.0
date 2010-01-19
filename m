Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J92Vfq178251 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:02:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4147311F97FD
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:03:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	PiYiMH4wRuoMmrVp for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 01:03:30 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11648324-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:33:28 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9zZ-0003gE-DX
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:17 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9zY-00083s-J5
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfsqa: Fix various test-suite related failures
Date: Tue, 19 Jan 2010 20:03:09 +1100
Message-Id: <1263891792-30952-1-git-send-email-david@fromorbit.com>
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

These are all code changes to the test suite to fix problems with
the execution of tests on a bleeding edge system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
