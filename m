Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n21HOKir167924 for <xfs@oss.sgi.com>; Sun, 1 Mar 2009 11:24:21 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C28AA16248A
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2009 09:23:51 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id s9VNN1h5eEuGtAls for <xfs@oss.sgi.com>;
	Sun, 01 Mar 2009 09:23:51 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Sun, 1 Mar 2009 18:23:09 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<200902280107.06699.agruen@suse.de> <49A9BA50.7050101@sandeen.net>
In-Reply-To: <49A9BA50.7050101@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903011823.09613.agruen@suse.de>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Greg Banks <gnb@melbourne.sgi.com>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Saturday, 28 February 2009 23:27:28 Eric Sandeen wrote:
> Andreas Gruenbacher wrote:
> > On Friday, 27 February 2009 0:03:00 Christoph Hellwig wrote:
> >> Do you plan to take over nfs4acl, too?
> >
> > I can sure copy the repository over from you if that is any help. How
> > that project will proceed is still unclear though, so don't expect a lot
> > to happen there anytime soon.
> >
> > Andreas
>
> I'd check in w/ Greg on that too, maybe?

Yes, makes sense. I've copied Christoph's tree over and set up permissions; 
you should have access now.

Greg doesn't have a kernel.org account yet, so I can't give him access at the 
moment.

  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/nfs4acl.git
  ssh://master.kernel.org/pub/scm/linux/kernel/git/agruen/nfs4acl.git

Would you like write access to the attr.git and acl.git trees as well?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
