Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p440gcdh043480 for <xfs@oss.sgi.com>; Tue, 3 May 2011 19:42:39 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4CEE42A378
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 17:46:15 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id 01bUUbs4DprJcBVd for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 17:46:15 -0700 (PDT)
Date: Tue, 3 May 2011 17:46:14 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
References: <20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

And another one, please see the files marked with 15- here:

   https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/

I tried to have more concise timestamps in each of these files, hope that 
helps. Sadly though, trace-cmd reports still segfaults on the tracefile.

Christian.
-- 
BOFH excuse #263:

It's stuck in the Web.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
