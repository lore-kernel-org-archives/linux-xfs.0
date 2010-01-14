Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EBZpGh256718 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 05:35:51 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B82391C4E7A5
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 03:36:47 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id dOYJiw7mfaMAUXqt for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 03:36:47 -0800 (PST)
Date: Thu, 14 Jan 2010 12:36:44 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS data corruption with high I/O even on hardware raid
Message-ID: <20100114113644.GL12241@basil.fritz.box>
References: <4B4E6F3F.1090901@chaven.com> <87hbqpf3zv.fsf@basil.nowhere.org>
	<4B4EFDD5.5060408@chaven.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B4EFDD5.5060408@chaven.com>
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
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 05:19:49AM -0600, Steve Costaras wrote:
> It's the current kernel for the distribution, however I take your point.    

The deal is usually -- when you stay with old distribution kernels
you have to contact the distribution for any problems.

> I did have a 2.6.28 kernel running on another system that also exhibited 

That's also a very old kernel in mainline terms. Current is 2.6.32

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
