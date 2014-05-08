Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 543F67F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 15:39:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 395C78F8039
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 13:39:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HOmvYUnGupbpfbQL for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 13:39:48 -0700 (PDT)
Date: Fri, 9 May 2014 06:39:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Remove xfs_check for 3.2.0?
Message-ID: <20140508203936.GV5421@dastard>
References: <536BCF95.201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536BCF95.201@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 08, 2014 at 01:40:21PM -0500, Eric Sandeen wrote:
> I think we had stated removal in June 2014, but it seems close enough.
> 
> Should xfs_check be removed prior to 3.2.0's release?

I'd prefer to do it slightly later than earlier.

As it is, 3.2.0 is really in the "critical fixes only" stage - like
that repair prefetch bug. So apart from fixes like that, I don't
want to be changing things right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
