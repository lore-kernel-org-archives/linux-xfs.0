Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23FtpGX020969 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 09:55:52 -0600
Date: Tue, 3 Mar 2009 10:55:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090303155523.GC26376@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200902280107.06699.agruen@suse.de> <49A9BA50.7050101@sandeen.net>
	<200903011823.09613.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903011823.09613.agruen@suse.de>
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
Cc: Mike Frysinger <vapier@gentoo.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Nathan Scott <nathans@debian.org>, Greg Banks <gnb@melbourne.sgi.com>

On Sun, Mar 01, 2009 at 06:23:09PM +0100, Andreas Gruenbacher wrote:
> Yes, makes sense. I've copied Christoph's tree over and set up permissions; 
> you should have access now.
> 
> Greg doesn't have a kernel.org account yet, so I can't give him access at the 
> moment.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/nfs4acl.git
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/agruen/nfs4acl.git
> 
> Would you like write access to the attr.git and acl.git trees as well?

Greg or me?  Don't think I want to do too much on it.  I'll just bounce
you whatever build system updates seem like fitting for acl/attr too.
Still a few I need to send you.

But Nathan Scott might want it as he wants to keep the debian packaging
in the upstream git, and I suspect acl/attr aren't different from the
xfs tools in that respect.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
