Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OIkt5B159957 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 12:46:55 -0600
Date: Tue, 24 Feb 2009 13:46:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090224184624.GC28007@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200902240953.56992.vapier@gentoo.org>
	<3C7B0B6E-1316-41CC-8846-356FDC780287@sgi.com>
	<200902241037.50534.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902241037.50534.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 24, 2009 at 10:37:49AM -0500, Mike Frysinger wrote:
> On Tuesday 24 February 2009 10:14:13 Felix Blyakher wrote:
> > On Feb 24, 2009, at 8:53 AM, Mike Frysinger wrote:
> > > the xfs.org wiki talks about git trees on sgi.com,
> >
> > Yes, they're still there.
> >
> > > but some of them are old
> > > and/or moved (like the xfs-cmds one) ...
> >
> > xfs-cmds was split into separate repos for xfsprogs, xfsdump,
> > and dmapi. And that info is on xfs.org.
> 
> but acl/attr have not.  distros care about those packages as well.

Andreas who has done most of the maintaince already is taking these over
formally, so they won't be released with the xfs tools anymore.  I've
put him on Cc so he can say when he expects to clear the backlog.

> > Here is the excerpt from the following page:
> 
> yes, i was reading the page.  i was also pointing out the broken link to the 
> xfs-cmds repo (which is after everything you quoted) and that that repo seems 
> to be dead now.  which means there is no up-to-date place for acl/attr on that 
> page.

Right now the most uptodate acl packages are the on on kernel.org, but
they will move (probably still on kernel.org, but not under fs/xfs)

> > At times though the repos on kernel.org could be ahead of sgi ones.
> 
> well if people are going to try to help in development, the kernel.org trees 
> would be good to mention on that page as well with a note as to which tree is 
> preferred (sgi.com or kernel.org).

I'll update the wikis to bring it uptodate.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
