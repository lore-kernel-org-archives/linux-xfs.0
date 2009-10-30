Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9UJmWT6247039 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 14:48:32 -0500
Date: Fri, 30 Oct 2009 12:48:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS (2 regression fixes)
In-Reply-To: <200910301857.n9UIvZ6w009983@stout.americas.sgi.com>
Message-ID: <alpine.LFD.2.01.0910301247480.31845@localhost.localdomain>
References: <200910301857.n9UIvZ6w009983@stout.americas.sgi.com>
MIME-Version: 1.0
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
To: Alex Elder <aelder@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Fri, 30 Oct 2009, Alex Elder wrote:
>
> Linus, Christoph Hellwig sent a pull request for these patches from
> the xfs-dev tree on kernel.org earlier today.  (Pointing this out to
> hopefully avoid confusion.)

I'll pull from Christophs tree directly - I refuse to pull from trees that 
have more merge commits than actual real commits.

		Linus
> Alex Elder (2):
>       Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus
>       Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus

Both of these seem pointless, and a sign of something wrong.

		Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
