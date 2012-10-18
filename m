Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I1Y5EP129215 for <xfs@oss.sgi.com>; Wed, 17 Oct 2012 20:34:05 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fxDhGQJ5GleU3OEC for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 18:35:41 -0700 (PDT)
Date: Thu, 18 Oct 2012 12:35:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: master branch fast-forwarded to v3.7-rc1
Message-ID: <20121018013538.GN2739@dastard>
References: <20121016155640.GA1377@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121016155640.GA1377@sgi.com>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 16, 2012 at 10:56:40AM -0500, Ben Myers wrote:
> Hi XFS Folks,
> 
> Linux v3.7-rc1 is out.  The XFS master branch
> (git://oss.sgi.com/xfs/xfs.git) has been fast-forwarded to v3.7-rc1.
> 
> We'd like to take a moment and let you all know that we at SGI are going
> to make an effort to communicate more from our end.  Your contribution
> is appreciated whether it be features, testing, reviews, docs,
> refactoring, cheerleading, or otherwise.  We want you here, and we want
> your help!  We'll continue to try to be as responsive as possible.

"we at SGI".

Curious. Has the XFS maintainer been replaced with a corporate
plurality? :/

FWIW:

http://lwn.net/SubscriberLink/519919/01a4caa1a34465f5/

"Developing in the community has a lot of rewards, including the
fact that credit for the work stays with the developer rather than
accruing to the sponsoring company.

> Please bear in mind that the master branch is a shared resource.  We XFS
> developers need a stable and bug free environment to work in and test
> our changes.  We simply cannot pull in work with known regressions
> because that can stop _all_ development until the problems are resolved.

I disagreed when you first indicated this is what you wanted to do a
couple of weeks ago:

http://oss.sgi.com/archives/xfs/2012-10/msg00124.html

but you didn't respond. I still disagree with it.

FYI, I don't need a stable and bug free environment to work in - I
haven't had one for years. That's because finding and fixing bugs is
what I do every day. I create tens of XFS bugs a day and I fix that
many as well. If the dev tree has bugs in it, then I'll find and fix
those as I trip over them. And I don't care whose bug the code is in
- if it stops me from continuing my line of development then my job
is to immediately find and fix that bug.  This is what *everyone*
use the dev tree should be doing - we are all responsible for finding
and fixing bugs in the XFS tree.

Regardless, instituting new development policies by decree is not
the best way to win friends and influence people in an open
development environment. You cannot force people to agree to new
policies, even as the maintainer. Change is made via discussion and
concensus, but you haven't engaged in disussion of this subject at
all.

Indeed, the development history of Linux and OSS in general points
to this policy change being the precisely the wrong direction to
take. At minimum, the benefits to developer productivity need to be
demonstrated before such a change should be made. Show us why this
is the right direction to take - tell us how you came to this
decision and how it will improve my productivity....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
