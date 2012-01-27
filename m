Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0R0QJwK060387 for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 18:26:20 -0600
Date: Fri, 27 Jan 2012 11:26:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS for-next branch
Message-ID: <20120127002602.GC15102@dastard>
References: <20120125171244.GX8262@sgi.com>
	<20120127110533.10304c6a33b83ac8e778915c@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120127110533.10304c6a33b83ac8e778915c@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jan 27, 2012 at 11:05:33AM +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> On Wed, 25 Jan 2012 11:12:44 -0600 Ben Myers <bpm@sgi.com> wrote:
> >
> > Could you pull XFS updates from
> > 
> > git://oss.sgi.com/xfs/xfs.git for-next
> > 
> > instead of from the oss/master branch for 3.3?
> 
> OK, currently I fetch the "master" branch of that tree.  And you want em
> to switch to the "for-next" branch, right?  (Those two branches currently
> point to the same commit, so I have not changed yet.)
> 
> Did you mean "3.3", or "3.4"?
> 
> Currently the contacts for that tree are: David Chinner
> <david@fromorbit.com>, xfs-masters@oss.sgi.com.  Should I change that?
> i.e. who has control over the tree and can fix problems if I report them?

I'd suggest changing the xfs-masters@oss.sgi.com address to just the
xfs list (xfs@oss.sgi.com) as more people will see it that way. You
can leave my email address there if you want because I'm in the same
timezone as you, Stephen. Ben is the only person that can manipulate
the tree, though, so you probably should add him to the list, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
