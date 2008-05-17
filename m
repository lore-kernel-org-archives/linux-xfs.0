Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 16:18:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HNI0F0010391
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:18:01 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F159A790449
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:18:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jT42TZS1RcpE7zkz for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:18:49 -0700 (PDT)
Message-ID: <482F67D9.70400@sandeen.net>
Date: Sat, 17 May 2008 18:18:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net>
In-Reply-To: <482EF6A7.2020909@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

Eric Sandeen wrote:

> I'll see if I have a little time today to track down the problem.


Does this patch fix it for you?  Does for me though I can't yet explain
why ;)

http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html

-Eric
