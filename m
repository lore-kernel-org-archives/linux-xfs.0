Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9K7recJ246581 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 02:53:40 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 881F11D5023
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 00:53:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9soPVbmOXehl43u9 for <xfs@oss.sgi.com>;
	Thu, 20 Oct 2011 00:53:38 -0700 (PDT)
Date: Thu, 20 Oct 2011 18:53:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Can you please create a git tree mirror on git.kernel.org?
Message-ID: <20111020075334.GH21338@dastard>
References: <4E9F8BE0.9010407@cn.fujitsu.com> <20111020035308.GG21338@dastard>
	<4E9FA3E9.4050507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E9FA3E9.4050507@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Thu, Oct 20, 2011 at 12:30:33PM +0800, Wanlong Gao wrote:
> On 10/20/2011 11:53 AM, Dave Chinner wrote:
> 
> > On Thu, Oct 20, 2011 at 10:48:00AM +0800, Wanlong Gao wrote:
> >> Hi Alex:
> >>
> >> 	I see that xfs,xfsprogs,xfstests,dmapi all have a mirror on
> >> 	git.kernel.org before kernel.org went down. Now, kernel.org goes on
> >> 	without the mirrors, so, can you create them now? I think someone
> >> 	will need them like me. Isn't it?
> > 
> > Just use the trees on oss.sgi.com - they are the "official" XFS
> > trees that releases are made from, anyway.
> 
> It's sure thing. Maybe it's an issue just for me because I can't access
> oss.sgi.com, so sad.

But you are obviously able to send email to it :/

> You know that our Chinese often can't access some sites because of
> the GFW(Great Fire Wall).

Yes, I know, but local political problems are not something we can
fix here.

As it is, I'm not sure we're going to put those trees back on
kernel.org - there's been no discussion I've seen about doing this,
and the absence of the trees hasn't hurt us at all thanks to Alex
pushing stuff into the oss.sgi.com trees quickly.

And FWIW, I'm not planning on putting my dev trees back on
kernel.org any time soon - too many hoops to jump through now. I'll
probably use github or some other site for doing that when the need
arises.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
