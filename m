Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S2CC4L241955 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 21:12:12 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4015F41AB09
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 19:15:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oWg2y2g1d16Yx2tN for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 19:15:44 -0700 (PDT)
Date: Thu, 28 Apr 2011 12:15:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfstests: dmapi: eliminate all build warnings
Message-ID: <20110428021541.GN12436@dastard>
References: <1303413073-24173-1-git-send-email-aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303413073-24173-1-git-send-email-aelder@sgi.com>
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

On Thu, Apr 21, 2011 at 02:11:08PM -0500, Alex Elder wrote:
> I'm hoping the Nth time is a charm...
> 
> This series eliminates all build warnings that come out of building
> things under the dmapi/ subdirectory.  I'm using gcc 4.x (x < 6) on
> several platforms, including i386, x86_64, and ia64 architectures.
> 
> I have sent these a couple times before; they are unmodified from
> the last time I sent them out.  I am omitting the summary of the
> types of warnings and how they got resolved this time around.

Nothing jumps out as wrong to me. Looks good.


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
