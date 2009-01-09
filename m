Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09284nB000426 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 20:08:07 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0159072C2A
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 18:08:03 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	v5CKncfyHUvvSOYt for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 18:08:03 -0800 (PST)
Date: Fri, 9 Jan 2009 13:08:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109020800.GO9448@disturbed>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net> <20090109004609.GM9448@disturbed>
	<20090109012610.GA23075@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109012610.GA23075@dth.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 09, 2009 at 02:26:10AM +0100, Danny ter Haar wrote:
> Do you want me to figure out what patch from git2->git3 is the cullprit ?
> I'll have to compile/reboot for a while.

If you can do that, it would be *greatly* appreciated.

> Tell me what else i can do to resolve this.

If you can isolate the commit that introduced the bug, then
code review is probably the step after that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
