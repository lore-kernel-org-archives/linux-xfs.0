Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB52E7F51
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 21:25:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9F8E304082
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 19:25:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fPVevXPr4CxcoToL for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 19:25:36 -0700 (PDT)
Date: Tue, 19 Aug 2014 12:25:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD]: Help in setting up XFS
Message-ID: <20140819022533.GE26465@dastard>
References: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
	<20140818070312.GM20518@dastard>
	<BLU181-W782ECB29BAB77090E0292A9CD40@phx.gbl>
	<alpine.LSU.2.11.1408181223400.5417@Telcontar.valinor>
	<20140818132026.GO20518@dastard>
	<alpine.LSU.2.11.1408181624430.5417@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408181624430.5417@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Mon, Aug 18, 2014 at 04:47:36PM +0200, Carlos E. R. wrote:
> On Monday, 2014-08-18 at 23:20 +1000, Dave Chinner wrote:
> >On Mon, Aug 18, 2014 at 12:25:57PM +0200, Carlos E. R. wrote:
> >>Just plug in the stick and click on the icon to mount it. No
> >>different than any other filesystem.
> >
> >That doesn't work for machines with no desktop or ones that you
> >access via ssh. Learn the command line first then you can always get
> >the machine to do what you want regardless of how you need to access
> >it. Indeed, typing commands is often faster than using the mouse,
> >especially if you know how to use command history search
> >effectively...
> 
> I use the CLI method myself, but I don't see the point on novices
> using it when there are modern methods far easier :-)

That's quite disrespectful and condescending towards new users who
are trying to learn new skills - you were once a novice, too. To
make my point unambiguously clear, I'll repeat what you just said as
it came across to me:

	'I'm an expert and I know the CLI, but I think he is a dumb
	n00b so I gave him a solution I think is appropriate for
	dumb n00bs even though I know I'm not answering the question
	he asked.'

Does that sound like appropriate "guidance" to you?

But I'll give you the benefit of the doubt - I've seen this often
enough to know that frequently people are not even aware they are
making unconcious judgements like this until they are pointed out.
Especially as you've done is again in this email:

> And each distribution has specifics. On ubuntu you probably need to
> do "sudo mount ...", a plain mount should fail. So if the
> generalized help an upstream mail list can provide, the best place
> to ask for help is the specific help forum of that distribution, as
> they will probably know best the easiest way to install and use the
> tools they provide.

You are implying that the XFS community doesn't have the knowledge
or experience to support XFS users from different distros.  You are
also implying that we don't care about our users enough to try to
help them in such situations where the problem is a distro specific
quirk. Years of experience has taught us that distro quirks really
don't matter anywhere near as much as, say, the version of software
being used.

Also, I suspect that you don't realise that we have all the major
distro XFS userspace package maintainers and the relevant distro
kernel filesystem maintainers on the list and listening in. We
actually have more distro specific storage infrastructure expertise
(not to mention overall storage expertise) on this list than you'll
find in most individual distro support forums.

This is a highly technical community and we tend to have high
standards w.r.t. to the quality of responses given to users.  If you
want to provide help to XFS users - new or experienced - on this
list, then please give relevant, respectful answers to questions
without trying to demonstrate your expertise to everyone.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
