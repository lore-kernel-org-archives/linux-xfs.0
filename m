Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6H1n2Nu019256 for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 20:49:02 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E96EC17DC3BE
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 18:48:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7IIcKjdaJsIXvXmU for <xfs@oss.sgi.com>;
	Sat, 16 Jul 2011 18:48:59 -0700 (PDT)
Date: Sun, 17 Jul 2011 11:48:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: don't hard code the shell binary
Message-ID: <20110717014856.GG21663@dastard>
References: <1309245348-12638-1-git-send-email-david@fromorbit.com>
	<20110628074137.GA6123@infradead.org>
	<1310668031.2067.44.camel@doink>
	<20110716180837.GA9429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110716180837.GA9429@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Sat, Jul 16, 2011 at 02:08:37PM -0400, Christoph Hellwig wrote:
> Dave, can you commit this one ASAP to all trees?  I just updated my test
> system and I'm hitting the issue too now.

Done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
