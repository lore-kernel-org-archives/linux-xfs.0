Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBK2Xtkm110297 for <xfs@oss.sgi.com>; Mon, 19 Dec 2011 20:33:55 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ntI0j3CajNS7w8U5 for <xfs@oss.sgi.com>;
	Mon, 19 Dec 2011 18:33:53 -0800 (PST)
Date: Tue, 20 Dec 2011 13:33:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs patches pw 2883, 2986-2997
Message-ID: <20111220023343.GU23662@dastard>
References: <4EEFC18F.4020705@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EEFC18F.4020705@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Dec 19, 2011 at 04:58:23PM -0600, Mark Tinguely wrote:
> Just a FYI to let you know that I testing your xfsprog patches that
> you submitted on Dec 2. I looked at the comments and the patches.
> The xfstests running now.
> 
> Dave Chinner had feedback requests on a couple items.

Yes, but Christoph has already replied so all I'm waiting on is a
repost of the series from him addressing those comments. He did say
it might take a while as he had other more critical stuff to do.

> Below is my summary of the patches:

I'd prefer it if you don't send emails this way - there's no context
to your comments about each patch. I'd have to go to a web browser
to start patchworks and look up some random index number and read
stuff before coming back to my email to comment sanely. That's way
to much stuffing about for me to bother - there's no way I can chew
through a couple of thousand emails a day with that sort of
workflow.

It is much better to reply in line to each of the patch emails with
your comments.  It is easy to understand the context of your
comments, you don't need to summarise all the patches (just reply to
ones you have comments about), and it fits the workflow we use for
tracking such comments (like patchworks). It also helps finding all
the discussion about a patch series in the mail archives. If you've
got a general comment about a series (like this email), reply to the
zero patch (the summary email).

Realistically, patchworks is just a tool to help the maintainer -
Ben - keep track of stuff if he requires help. It was set up because
Alex found it useful for this purpose, but if Ben doesn't need it
then it's probably not going to be maintained. Ben can weigh in on
this, though.....

FWIW, we talk quite a bit about bugs, patches, review and dev work
in #xfs (there's 50 people in the channel at the moment), so what
you see on the mailing list is often not the entire picture. There's
a lot more day to day dev stuff go on there -  what you see on the
mailing list is often the end result of something that was first
discussed on #xfs. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
