Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0AGj727024524 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 10:45:07 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: Re: [PATCH v2] xfs: Don't flush stale inodes
Date: Sun, 10 Jan 2010 10:43:56 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6940@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100109223920.GA4019@discord.disaster>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Sat, Jan 09, 2010 at 10:22:14AM -0600, Alex Elder wrote:
>> Yes, I see that now.  I had marked your older one "Reviewed" and
>> didn't look further.  I will re-do the port and will re-submit.
>> BTW I also plan to port the perag radix tree patch(es) over this
>> for you after I get this one published.
> 
> Don't make extra work for yourself that slows down the rate at which
> you can merge stuff. When the tree is updated with these patches,
> I'll fix any conflicts in my patches and retest them, then send them
> to the list again.

You are right.  And I do very much want to keep improving
the turnaround for merges.

> As a maintainer, manually munging a bunch patches around to fit,
> then asking if they are correct, then finally merging them doesn't
> scale - push that work back out to the patch authors where it does
> scale and who have probably already done the work.... ;)

Right again, and I will gladly do this from here forward.
Remind me if I stray off course again...

Thanks a lot Dave.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
