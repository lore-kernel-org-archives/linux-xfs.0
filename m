Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6L5IZk1062459 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 00:18:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 635E2BEBD7C
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 22:28:21 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	RRoIK4AtIsAXPCkC for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 22:28:21 -0700 (PDT)
Date: Wed, 21 Jul 2010 15:21:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] Shrinker fixes for XFS for 2.6.36-rc6
Message-ID: <20100721052128.GU32635@dastard>
References: <20100720004630.GH23223@dastard> <20100720233238.GS32635@dastard>
	<AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 20, 2010 at 04:35:14PM -0700, Linus Torvalds wrote:
> On Tue, Jul 20, 2010 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Ijust rebased the series - the shrinker context patch did not pickup
> > the new shrinker in the TTM DRM code for radeon. New pull-request output
> > below.
> 
> Not good. I already pulled the earlier version yesterday. So a rebased
> series is useless.

OK, I checked your public tree and didn't see it there before I did
the rebase. I'll send you a delta patch shortly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
