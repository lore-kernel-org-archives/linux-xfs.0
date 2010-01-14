Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E97Q5E244689 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 03:07:27 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 452D4164DBA
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 01:08:22 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id poBEBn9EY1XlbaUP for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 01:08:22 -0800 (PST)
Subject: Re: XFS data corruption with high I/O even on hardware raid
From: Andi Kleen <andi@firstfloor.org>
References: <4B4E6F3F.1090901@chaven.com>
Date: Thu, 14 Jan 2010 10:08:20 +0100
In-Reply-To: <4B4E6F3F.1090901@chaven.com> (Steve Costaras's message of "Wed,
	13 Jan 2010 19:11:27 -0600")
Message-ID: <87hbqpf3zv.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
To: Steve Costaras <stevecs@chaven.com>
Cc: xfs@oss.sgi.com

Steve Costaras <stevecs@chaven.com> writes:
>
> ============ (System)
> (Ubuntu 8.04.3 LTS):
> Linux loki 2.6.24-26-server #1 SMP Tue Dec 1 18:26:43 UTC 2009 x86_64 GNU/Linux

That's a really old kernel. Perhaps try it with a newer one?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
