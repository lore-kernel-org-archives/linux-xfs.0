Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 56EF67F6D
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:09:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9DC4AC001
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 14:09:44 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZPJGGbTdf9GGF9tB for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 14:09:43 -0800 (PST)
Date: Tue, 26 Feb 2013 09:09:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/10] xfstests: Stress tests improments v5
Message-ID: <20130225220941.GH5551@dastard>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<20130225154512.GA32171@thunk.org> <20130225212811.GY22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130225212811.GY22182@sgi.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Dmitry Monakhov <dmonakhov@openvz.org>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, Feb 25, 2013 at 03:28:11PM -0600, Ben Myers wrote:
> Hey Ted,
> 
> On Mon, Feb 25, 2013 at 10:45:12AM -0500, Theodore Ts'o wrote:
> > Hi, what's the status of this patch series?  It looks like Dmitry has
> > responded to all of Dave's concerns --- is that correct?
> > 
> > Is there anything else we need to do before these patches get merged
> > into the xfstests git tree?
> 
> I think we just need a review to see if Dave's concerns have been addressed and
> then we're ready to go.

That doesn't stop anyone else from reviewing it. I've got my hands
full right now, and doing stuff like reviewing patches that
nobody else seems to want to look at is something that I'm doing
when I have a little spare time.

I've already reviewed al the patches and the changes have been made,
so all my final review is going to be is validating the patches
apply and work as advertised, so anyone really can do that. I
couldn't do that last time around because the patches didn't apply
to my tree. Since then I haven't had a slot available to go back and
look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
