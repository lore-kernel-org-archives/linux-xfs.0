Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0WGYN141599 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:32:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FA4011F8B87
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:33:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	lRma6DyCGUvTxYCk for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:33:15 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11542992-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:03:14 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX21v-0003E7-Lm
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:33:11 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX21v-0003Xm-0J
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:33:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: Cleaner build output
Date: Tue, 19 Jan 2010 11:33:04 +1100
Message-Id: <1263861186-13589-1-git-send-email-david@fromorbit.com>
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

This is basically the same change that I last posted, but with the
"don't remove configure on make clean" bits split into a separate
patch as Christoph asked.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
