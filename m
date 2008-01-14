Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 10:05:41 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EI5ZF2023586
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 10:05:36 -0800
Received: from mail3.key-systems.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id DF64C5194D9
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 10:05:53 -0800 (PST)
Received: from mail3.key-systems.net (mail3.key-systems.net [81.3.43.213]) by cuda.sgi.com with SMTP id YL9yS3c5tSVJ3fFC for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 10:05:53 -0800 (PST)
Subject: binary NULL errors
From: Christoph Anton Mitterer <calestyo@scientia.net>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 19:05:49 +0100
Message-Id: <1200333949.3145.33.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi.

I've got some questions about using XFS.

I've already used it as for all my discs about one or two years ago, but
then I've suffered several times from the binary NULLs "bug", that
happened when the system crashed or had a power loss.

I've lost more than one open files (like all my bookmarks in Firefox)
and thus I've switched back to ext3

In the FAQ at http://oss.sgi.com/projects/xfs/faq.html it says:
Update: This issue has been addressed with a CVS fix on the 29th March
2007 and merged into mainline on 8th May 2007 for 2.6.22-rc1.

What does this exactly mean and what has been fixed/addressed?
Is XFS now similar to ext3 and I won't see those binary NULLs stuff
again?

What happens now in case of a powerloss? Does XFS still make heavy use
of caching techniques?

Best wishes,
Chris,
