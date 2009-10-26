Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9QMaE8J259922 for <xfs@oss.sgi.com>; Mon, 26 Oct 2009 17:36:14 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91CF417CC4B8
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2009 15:37:51 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 9QCL9ouqtKcGnDIT for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2009 15:37:51 -0700 (PDT)
Message-ID: <4AE624BE.8020807@sandeen.net>
Date: Mon, 26 Oct 2009 17:37:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs 3.0.5 "release"
References: <20091025070331.GA21120@infradead.org>
In-Reply-To: <20091025070331.GA21120@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: nathans@debian.org, vapier@gentoo.org, xfs@oss.sgi.com

Christoph Hellwig wrote:
> It looks like SGI rushed out a 3.0.5 xfsprogs release which contains
> various half-cooked changes including additions to shared libraries
> without bumping the minor version and wrong patch attributions.
> 
> I can only recommend to not pick it up for distributions and wait for a
> proper release from the kernel.org trees after the full release
> engineering process has finished.  The current plan is to have a release
> end of Novemeber, we'll have to figure out the naming / numbering to not
> clash with the SGI versions.

Alex did ping me about doing a release, and I didn't complain, so sorry 
about that.  I hadn't really looked in detail at what was in the tree, 
and the library change totally escaped me.

So Alex isn't working in a total vacuum, but he consulted a total 
air-head I guess.  ;)

Let's work to fix the trees and give Alex another shot; I understand the 
frusttation with SGI, and I share it, for constantly putting new (new as 
in "green") maintainers in place, but I think Alex is doing his best on 
short notice.

Anyway I share some of the blame, let's not go for the nuclear option 
yet, if there's still a little patience left on your part, Christoph.

I do feel like if time goes by and SGI's only role continues to be 
playing patch-monkey by pulling others' changes into their tree, that's 
not maintaining, an we should just cut releases on our own... but I'm 
willing to give it a little more time, based on what I know of Alex's 
interest & abilities here.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
