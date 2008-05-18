Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 08:37:45 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4IFbguJ016021
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 08:37:42 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F3EF16E9FCD
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 08:38:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 20rkGOzv0P1znD8u for <xfs@oss.sgi.com>; Sun, 18 May 2008 08:38:31 -0700 (PDT)
Message-ID: <48304D77.1090803@sandeen.net>
Date: Sun, 18 May 2008 10:38:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com>
In-Reply-To: <482FED60.7060405@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, LinuxRaid <linux-raid@vger.kernel.org>

David Greaves wrote:
> Eric Sandeen wrote:


> mmmm
> 'little buglets' in the filesystem holding a few Tb of data...
> mmmm
> Anything I can do to help find that? I suspect not if you can reproduce it.

Nah.  I'll ask the sgi guys about it, it just seems a little
inconsistent but maybe by design...

-Eric

> Anyhow - thanks again.
> 
> David
> PS I'll be back soon, back in 2.6.23 I was hitting a hibernate/xfs bug which
> I've been avoiding by powering down. Well, it's still there in 2.6.25.3...
> 
