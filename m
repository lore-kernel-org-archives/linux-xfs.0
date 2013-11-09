Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B3DC7F53
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 17:17:15 -0600 (CST)
Date: Sat, 9 Nov 2013 17:17:11 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] update xfs maintainers
Message-ID: <20131109231711.GR10553@sgi.com>
References: <527C4B27.6020205@redhat.com> <527CC50D.4060905@redhat.com>
	<20131108180337.GO10553@sgi.com>
	<20131108193424.GA11052@infradead.org>
	<20131108204605.GA1935@sgi.com> <527D4E8D.3000109@redhat.com>
	<20131108220309.GB1935@sgi.com> <527D60B1.7000901@redhat.com>
	<20131108221744.GQ10553@sgi.com> <527D7491.2030006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <527D7491.2030006@redhat.com>
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
To: Ric Wheeler <rwheeler@redhat.com>
Cc: elder@kernel.org, Mark Tinguely <tinguely@sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Fri, Nov 08, 2013 at 06:32:33PM -0500, Ric Wheeler wrote:
> On 11/08/2013 05:17 PM, Ben Myers wrote:
> >Hey Ric,
> >
> >On Fri, Nov 08, 2013 at 05:07:45PM -0500, Ric Wheeler wrote:
> >>On 11/08/2013 05:03 PM, Ben Myers wrote:
> >>>Hey Ric,
> >>>
> >>>On Fri, Nov 08, 2013 at 03:50:21PM -0500, Ric Wheeler wrote:
> >>>>On 11/08/2013 03:46 PM, Ben Myers wrote:
> >>>>>Hey Christoph,
> >>>>>
> >>>>>On Fri, Nov 08, 2013 at 11:34:24AM -0800, Christoph Hellwig wrote:
> >>>>>>On Fri, Nov 08, 2013 at 12:03:37PM -0600, Ben Myers wrote:
> >>>>>>>Mark is replacing Alex as my backup because Alex is really busy at
> >>>>>>>Linaro and asked to be taken off awhile ago.  The holiday season is
> >>>>>>>coming up and I fully intend to go off my meds, turn in to Fonzy the
> >>>>>>>bear, and eat my hat.  I need someone to watch the shop while I'm off
> >>>>>>>exploring on Mars.  I trust Mark to do that because he is totally
> >>>>>>>awesome.
> >>>>>>Doing this as an unilateral decisions is not something that will win you
> >>>>>>a fan base.
> >>>>>It's posted for review.
> >>>>>
> >>>>>>While we never had anything reassembling a democracy in Linux Kernel
> >>>>>>development making decisions without even contacting the major
> >>>>>>contributor is wrong, twice so if the maintainer is a relatively minor
> >>>>>>contributor to start with.
> >>>>>>
> >>>>>>Just because it recent came up elsewhere I'd like to recite the
> >>>>>>definition from Trond here again:
> >>>>>>
> >>>>>>	http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000066.html
> >>>>>>
> >>>>>>By many of the creative roles enlisted there it's clear that Dave should
> >>>>>>be the maintainer.  He's been the main contributor and chief architect
> >>>>>>for XFS for many year, while the maintainers came and went at the mercy
> >>>>>>of SGI.  This is not meant to bad mouth either of you as I think you're
> >>>>>>doing a reasonably good job compared to other maintainers, but at the
> >>>>>>same time the direction is set by other people that have a much longer
> >>>>>>involvement with the project, and having them officially in control
> >>>>>>would help us forward a lot.  It would also avoid having to spend
> >>>>>>considerable resources to train every new generation of SGI maintainer.
> >>>>>>
> >>>>>>Coming to and end I would like to maintain Dave Chinner as the primary
> >>>>>>XFS maintainer for all the work he has done as biggest contributor and
> >>>>>>architect of XFS since longer than I can remember, and I would love to
> >>>>>>retain Ben Myers as a co-maintainer for all the good work he has done
> >>>>>>maintaining and reviewing patches since November 2011.
> >>>>>I think we're doing a decent job too.  So thanks for that much at least.  ;)
> >>>>>>I would also like to use this post as a public venue to condemn the
> >>>>>>unilateral smokey backroom decisions about XFS maintainership that SGI is
> >>>>>>trying to enforce on the community.
> >>>>>That really didn't happen Christoph.  It's not in my tree or in a pull request.
> >>>>>
> >>>>>Linus, let me know what you want to do.  I do think we're doing a fair job over
> >>>>>here, and (geez) I'm just trying to add Mark as my backup since Alex is too
> >>>>>busy.  I know the RH people want more control, and that's understandable, but
> >>>>>they really don't need to replace me to get their code in.  Ouch.
> >>>>>
> >>>>>Thanks,
> >>>>>	Ben
> >>>>Christoph is not a Red Hat person.
> >>>>
> >>>>Jeff is from Oracle.
> >>>>
> >>>>This is not a Red Hat vs SGI thing,
> >>>Sorry if my read on that was wrong.
> >>I do appreciate the work and effort you and the SGI team put in but
> >>think that this will be a good way to keep the community happier and
> >>even more productive going forward.
> >>
> >>>>Dave simply has earned the right
> >>>>to take on the formal leadership role of maintainer.
> >>>Then we're gonna need some Reviewed-bys.  ;)
> >>Those should come from the developers, thanks!
> >I actually do need your Reviewed-by.   We'll try and get this one in 3.13.  ;)
> >
> >Thanks,
> >	Ben
> 
> Happy to do that - I do think that Dave mostly posts from his
> redhat.com account, but he can comment once he gets back online.
> 
> Reviewed-by: Ric Wheeler <rwheeler@redhat.com>

Thanks Ric.  ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
