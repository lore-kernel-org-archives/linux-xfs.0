Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99LROTQ108277 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 16:27:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	U7bJj8NKG8BDdNgX for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 14:28:53 -0700 (PDT)
Date: Wed, 10 Oct 2012 08:28:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/14] xfs: xfs_sync_data is redundant.
Message-ID: <20121009212851.GP23644@dastard>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<1349693772-8064-7-git-send-email-david@fromorbit.com>
	<20121009210124.GT13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121009210124.GT13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 04:01:24PM -0500, Ben Myers wrote:
> Hi Brain,

[Pinky: "Gee, Brain, what do you want to do tonight?"
 Brain: "The same thing we do every night, Pinky - try to take over
        the world!"]

> Given that you found the regression in the output of xfstest 273, could you do
> us a favor and review the fix and provide your Reviewed-by, and/or Tested-by?

Brian did test it, just as separate patches:

http://oss.sgi.com/archives/xfs/2012-10/msg00037.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
