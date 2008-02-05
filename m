Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 06:25:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15EPCk9032031
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 06:25:14 -0800
Received: from malkusch.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C4A7D77A94
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 06:25:32 -0800 (PST)
Received: from malkusch.de (malkusch.de [217.171.203.96]) by cuda.sgi.com with ESMTP id owNL9jUBcZDGfXmH for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 06:25:32 -0800 (PST)
Received: from massmann.mhn.de ([129.187.19.220] helo=ferrara.massmann.mhn.de)
	by malkusch.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68)
	(envelope-from <malkusch@malkusch.de>)
	id 1JMOjr-0006vk-11
	for xfs@oss.sgi.com; Tue, 05 Feb 2008 15:25:31 +0100
From: Markus Malkusch <markus@malkusch.de>
Subject: xfs_repair progress
Date: Tue, 5 Feb 2008 15:25:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051525.25101.markus@malkusch.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_repair 2.9.4 is running since 3 days. It's still since those 3 days at 
Phase 3 agno = 0. Is there a possibility to look if xfs_repair is doing 
progress (it is using 107% CPU)?

The filesystem is 4,6T large. I don't know how many Inodes there are and I 
can't look right now as xfs_repair is running, but there are lots as I have 
several hardlinks of all files.

Markus Malkusch

PS: Could you CC me, because I'm not on the mailinglist.
