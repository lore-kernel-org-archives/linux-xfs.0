Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LKvJiR030395 for <xfs@oss.sgi.com>; Fri, 21 May 2010 15:57:19 -0500
Subject: Re: [PATCH 07/12] xfs: Improve scalability of busy extent tracking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100521021619.GV8120@dastard>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-8-git-send-email-david@fromorbit.com>
	<1274386538.2095.148.camel@doink>  <20100521021619.GV8120@dastard>
Date: Fri, 21 May 2010 15:59:35 -0500
Message-ID: <1274475575.2255.36.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2010-05-21 at 12:16 +1000, Dave Chinner wrote:
> On Thu, May 20, 2010 at 03:15:38PM -0500, Alex Elder wrote:
> > On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
. . .
> FWIW, Alex, this code has been out there for some time now - could
> you please attempt to review code before the last minute? Your
> reviews are valuable and feedback like this while I was having
> trouble with this code would have helped a great deal. However, now
> I'm pressed for time to retest significant modifications right
> before a merge deadline....

I'm really sorry Dave.  I've been meaning to do this review
for literally weeks, but have been repeatedly preempted by
other things.  I actually thought Linus wouldn't release
the 2.6.34 as quickly as he did after -rc7, and expected
I'd have another week or more to review this.

In any case I'll put a better priority on it in the
future--especially when we approach the start of a new
release cycle.

					-Alex



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
