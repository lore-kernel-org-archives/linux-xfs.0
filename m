Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E8lK4n242999 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:47:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58F951DB0ECC
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 00:48:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	ayxVnUYr4FRD7XlR for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 00:48:16 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11435612-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 19:18:15 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVLNA-0007m4-11
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 19:48:08 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVLJ6-0005Ug-It
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 19:43:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfsprogs: fix compile warnings in libxfs
Date: Thu, 14 Jan 2010 19:43:48 +1100
Message-Id: <1263458631-21084-1-git-send-email-david@fromorbit.com>
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

First in a bunch of patches to make xfsprogs compile cleanly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
