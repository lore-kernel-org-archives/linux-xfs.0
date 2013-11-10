Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40A5B7F61
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 17:12:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BC268F8049
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 15:12:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4t0DrX4ZxuI0KqY7 for <xfs@oss.sgi.com>;
	Sun, 10 Nov 2013 15:12:46 -0800 (PST)
Date: Mon, 11 Nov 2013 10:12:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] update xfs maintainers
Message-ID: <20131110231241.GQ6188@dastard>
References: <527CC50D.4060905@redhat.com> <20131108180337.GO10553@sgi.com>
	<20131108193424.GA11052@infradead.org>
	<20131108204605.GA1935@sgi.com> <527D4E8D.3000109@redhat.com>
	<20131108220309.GB1935@sgi.com>
	<CAEH94LidwFnLX7cxetBAAzYzRGL+pc96egDNKPFKuPYcqKOtNg@mail.gmail.com>
	<20131109104424.45b71dac@notabene.brown>
	<20131109235130.GS10553@sgi.com> <20131110003049.GD1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131110003049.GD1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, elder@kernel.org, Mark Tinguely <tinguely@sgi.com>, NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Nov 09, 2013 at 06:30:49PM -0600, Ben Myers wrote:
> On Sat, Nov 09, 2013 at 05:51:30PM -0600, Ben Myers wrote:
> > On Sat, Nov 09, 2013 at 10:44:24AM +1100, NeilBrown wrote:
> > > On Sat, 9 Nov 2013 06:59:00 +0800 Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> > > > On Sat, Nov 9, 2013 at 6:03 AM, Ben Myers <bpm@sgi.com> wrote:
> > > > > On Fri, Nov 08, 2013 at 03:50:21PM -0500, Ric Wheeler wrote:
> > > > >> On 11/08/2013 03:46 PM, Ben Myers wrote:
> > > > >> >Hey Christoph,
> > > > >> >
> > > > >> >On Fri, Nov 08, 2013 at 11:34:24AM -0800, Christoph Hellwig wrote:
> > > > >> >>On Fri, Nov 08, 2013 at 12:03:37PM -0600, Ben Myers wrote:
> > > > >> >>>Mark is replacing Alex as my backup because Alex is really busy at
> > > > >> >>>Linaro and asked to be taken off awhile ago.  The holiday season is
> > > > >> >>>coming up and I fully intend to go off my meds, turn in to Fonzy the
> > > > >> >>>bear, and eat my hat.  I need someone to watch the shop while I'm off
> > > > >> >>>exploring on Mars.  I trust Mark to do that because he is totally
> > > > >> >>>awesome.
> > > > >> >>
> > > > >> >>Doing this as an unilateral decisions is not something that will win you
> > > > >> >>a fan base.
> > > > >> >It's posted for review.
> > > > >> >
> > > > >> >>While we never had anything reassembling a democracy in Linux Kernel
> > > > >> >>development making decisions without even contacting the major
> > > > >> >>contributor is wrong, twice so if the maintainer is a relatively minor
> > > > >> >>contributor to start with.
> > > > >> >>
> > > > >> >>Just because it recent came up elsewhere I'd like to recite the
> > > > >> >>definition from Trond here again:
> > > > >> >>
> > > > >> >>    http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000066.html

Yup, and my take on the role of a Maintainer is here:

http://oss.sgi.com/archives/xfs/2013-08/msg00633.html

> > > > >  P:     Silicon Graphics Inc
> > > > > +M:     Dave Chinner <dchinner@fromorbit.com>

I flattered by this, but there is a reason I've resisted taking this
position for a long time. Mainly for the reasons already mentioned:

> > > Indeed.  And does he even want the job?  I heard Linus say in a recent
> > > interview that being a maintainer is a $#!+ job. 
> > 
> > I've found that it can be a little bit stressful sometimes and it tends to
> > crowd out feature work, so I guess I agree with him.  It turns out to be an
> > excellent weight loss plan.

which are all true, but I'm already pulling most patches off the
list, applying them to my own trees, testing them and reviewing
them. Hence juggling them into a stable, non-rebasing git tree
branch on a server somewhere isn't a huge amount of extra work...

> > > Is it really best for the
> > > most active developers to be burdened with that extra work?
> > > 
> > > (hmm.. maybe I should add Dave to the Cc here .. but no-one else did so best
> > > leave him alone to code in peace).
> > 
> > Dave, what do you want to do here?  Which email?  What sort of arrangement?  I
> > gather that you probably do want the job, and I know you'll be fantastic.  Do
> > you want to do it all yourself?  Maybe split it up?
> 
> I should have also suggested that we can add you to this file and just keep our
> existing arrangements.  That seems appropriate to me, befitting of your
> achievements, the work you've been doing, and I'm willing to keep on as I am.

OK, I've read the thread and had a think about it. My thoughts are
as follows....

I'm not interested in being a co-maintainer in name only or only as
a backup to only be used when Ben goes on holidays.

Co-maintainer means SGI is giving me all the access and admin rights
needed to commit and maintain git trees on oss.sgi.com (including
creating new trees) at any time, at any point in a release cycle,
etc. i.e. I can do anything that Ben can currently do on
oss.sgi.com from XFS POV...

Co-maintainer is not a kernel-tree only deal. It's for everything
XFS related: kernel code, xfsprogs, xfstests and xfsdump.

Co-maintainer does not mean "Dave does everything". Yes, I can do a
lot of the heavy lifting, but I'm very happy for Ben to continue
committing patches he reviews and handling userspace releases and
pushing stuff to Linus and so on.  There's some logistics we need to
work out here so we aren't going to step on each other's toes, but
there's no unsolvable issues here.

Co-maintainer is not a role I will perform with a Red Hat on. I will
review and sign off on anything in my co-maintainer role as
"david@fromorbit.com". Hence I hope to be able to maintain a clear
distinction between the duties I perform on behalf of the community
and code that I write on Red Hat's behalf.

Lastly, being a maintainer doesn't solve the problem of review
latency of the code I write. I'm hoping that everyone understands
that maintainers are still dependent on the receiving help from the
community they serve to get their own work done.

Ben, let's talk more about the logistics of this offline first
before making anything official....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
