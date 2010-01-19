Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J8wigX177982 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 02:58:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AFD3173462
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 00:59:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	JVyRrSKlIkjEBTj1 for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 00:59:43 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11709900-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:29:42 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9w3-0003fK-9n
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 19:59:39 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9w2-00080v-FS
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 19:59:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfstests: clean up build output V2
Date: Tue, 19 Jan 2010 19:59:32 +1100
Message-Id: <1263891574-30762-1-git-send-email-david@fromorbit.com>
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

Essentially the same result as before, bu split into two patches;
one for the top level makefile and rules cleanup and a second
for the common target rules cleanup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
