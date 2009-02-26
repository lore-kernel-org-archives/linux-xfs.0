Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1QAjZcG252598 for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 04:45:36 -0600
Received: from smtp5m5.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AB43156F28
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 02:45:05 -0800 (PST)
Received: from smtp5m5.poczta.onet.pl (smtp5m5.poczta.onet.pl
	[213.180.138.36]) by cuda.sgi.com with ESMTP id
	iNl9QBLJKVkOQ5E0 for <xfs@oss.sgi.com>;
	Thu, 26 Feb 2009 02:45:05 -0800 (PST)
Received: from ip-83-238-22-2.netia.com.pl ([83.238.22.2]:33870 "EHLO
	[192.168.242.3]" rhost-flags-OK-FAIL-OK-FAIL) by ps5.mod5.onet
	with ESMTPA id S50371421AbZBZKoQ3CAZH (ORCPT
	<rfc822;xfs@oss.sgi.com>); Thu, 26 Feb 2009 11:44:16 +0100
Message-ID: <49A67288.5060301@poczta.onet.pl>
Date: Thu, 26 Feb 2009 11:44:24 +0100
From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: XFS_repair and memory consumption
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello

I have a few question about xfs_repair and memory consumption

I have 12 TB storage,2GB RAM and 2.6.27 32b and someday my power down.
After started system, I tried xfs_repair for this storage (because I
can`t mount this) with unsuccessful. Maybe I am in the wrong but I know
that xfs_repair need about 2GB of memory per terabyte of file system space.

Is any possible to run xfs_repair without 24GB RAM (in my case) ? Maybe
I should use big SWAP instant of so much RAM?

What is the difference running XFS_repair in 32 and 64 bit kernel?If any
difference existing,  how much RAM must be in system with (for example)
64TB in single volume in order to run XFS_repair

Very thanks



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
