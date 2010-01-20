Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K1OxMU229751 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:24:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F8AC11F8E09
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 17:25:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	3DfOZeFUkSJIEsSX for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 17:25:57 -0800 (PST)
Date: Wed, 20 Jan 2010 12:25:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] xfs: Warning fixes for 2.6.34
Message-ID: <20100120012554.GH14035@discord.disaster>
References: <20100120003350.GF14035@discord.disaster>
	<20100120004056.GG14035@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100120004056.GG14035@discord.disaster>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Jan 20, 2010 at 11:40:56AM +1100, Dave Chinner wrote:
> On Wed, Jan 20, 2010 at 11:33:50AM +1100, Dave Chinner wrote:
> > Alex,
> > 
> > This is the series that Christoph reviewed this morning. I've fixed
> > up the hunks that were in the wrong patch. Please pull.
> > 
> > ----
> > 
> > The following changes since commit 4e23471a3f3aba885ea70100db47ccacb5f069f6:
> >   Christoph Hellwig (1):
> >         xfs: move more buffer helpers into xfs_buf.c
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git warnings
> 
> Looks like something has gone wrong when I pushed the warnings
> branch - I can't pull this tree right now. I'll get back to you...

Ok, recloned my staging tree and re-pushed to the kernel.org tree, and it
appears to be working now. I don't know what was wrong, but it's
working now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
