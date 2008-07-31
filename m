Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 20:48:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6V3miEX025148
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 20:48:44 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46D23EE11E6
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 20:49:56 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id VdJBt1hL3nUbZ4aG for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 20:49:56 -0700 (PDT)
Date: Thu, 31 Jul 2008 13:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] XFS update for 2.6.27
Message-ID: <20080731034952.GC13395@disturbed>
References: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

On Thu, Jul 31, 2008 at 12:53:28PM +1000, Lachlan McIlroy wrote:
> The following changes since commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b:
>   Linus Torvalds (1):
>         Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com:8090/xfs/xfs-pull for-linus
.....
> 
> Lachlan McIlroy (11):
>       [XFS] Use the generic xattr methods.
.....
>       [XFS] Use the generic xattr methods.

BTW, that's a patch from Christoph, so there's a mistake in the
author of that patch. I don't know why there's duplicates of it
in the tree - the only thing I can see is that the committer's
email address is not stable. There is a growing number of
duplicate commits like this in the XFS tree.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
