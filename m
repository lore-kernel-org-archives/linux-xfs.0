Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1QN45CC013981 for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 17:04:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01F3619B2725
	for <xfs@oss.sgi.com>; Thu, 26 Feb 2009 15:03:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dolbSzsPJIqUmtfY for
	<xfs@oss.sgi.com>; Thu, 26 Feb 2009 15:03:36 -0800 (PST)
Date: Thu, 26 Feb 2009 18:03:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090226230300.GA6289@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200902241037.50534.vapier@gentoo.org>
	<20090224184624.GC28007@infradead.org>
	<200902242322.48314.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902242322.48314.agruen@suse.de>
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
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 24, 2009 at 11:22:48PM +0100, Andreas Gruenbacher wrote:
> On Tuesday, 24 February 2009 19:46:24 Christoph Hellwig wrote:
> > On Tue, Feb 24, 2009 at 10:37:49AM -0500, Mike Frysinger wrote:
> > > but acl/attr have not.  distros care about those packages as well.
> >
> > Andreas who has done most of the maintaince already is taking these over
> > formally, so they won't be released with the xfs tools anymore.  I've
> > put him on Cc so he can say when he expects to clear the backlog.
> 
> I think I have caught up with the backlog by now in my current trees:
> 
>   http://git.kernel.org/?p=linux/kernel/git/agruen/attr.git
>   http://git.kernel.org/?p=linux/kernel/git/agruen/acl.git
> 
> The repos are based on Christoph's initial git import, with all additional 
> fixes added that I'm aware of. Please let me know if anything is missing.

Do you plan to take over nfs4acl, too?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
