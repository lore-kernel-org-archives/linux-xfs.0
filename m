Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BMPlrB025119 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 17:25:47 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2426D1C8020B
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 15:25:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5X1Y9XpUI9zkEjdW for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 15:25:45 -0700 (PDT)
Date: Wed, 12 Oct 2011 09:25:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TRIM on XFS
Message-ID: <20111011222542.GD3159@dastard>
References: <201110071352.20135@zmi.at> <20111007233450.GK3159@dastard>
	<201110100829.45823@zmi.at>
	<CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
	<4E936BFB.5060907@mnsu.edu> <20111011020552.GY3159@dastard>
	<4E946980.4060702@mnsu.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E946980.4060702@mnsu.edu>
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
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com

On Tue, Oct 11, 2011 at 11:06:24AM -0500, Jeffrey Hundstad wrote:
> Dave,
> 
> Thank you.  I suspected this may be the case.  It is awfully nice to
> have a definitive answer though.  It is especially nice to have a
> way to determine if it is possible.  Thank you!
> 
> I've created a an XFS Wiki page for this info:
>     http://xfs.org/index.php/FITRIM/discard

Great!

Looks good - I'll just have to find out which release online discard
first appeared in (different to FITRIM) and add that to the
description of it, but otherwise it looks good. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
