Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o72NE0Nr211083 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 18:14:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27AAA48D7FB
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 16:14:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	0Pf2G1ETs728g6fz for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 16:14:18 -0700 (PDT)
Date: Tue, 3 Aug 2010 09:14:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: dmapi: fix depend targets
Message-ID: <20100802231415.GG19164@dastard>
References: <201007302151.o6ULpNLX008602@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007302151.o6ULpNLX008602@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 04:51:23PM -0500, Alex Elder wrote:
> There's no need to re-make the dependency files all the time.  Make
> it so the "depend" target rebuilds the ".dep" file only if necessary.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
