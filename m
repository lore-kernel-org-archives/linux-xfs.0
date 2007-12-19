Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 19:12:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ3CLOF017544
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 19:12:25 -0800
Date: Wed, 19 Dec 2007 14:12:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc6
Message-ID: <20071219031225.GB4612@sgi.com>
References: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com> <20071219004126.GS4396912@sgi.com> <alpine.LFD.0.9999.0712181718430.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712181718430.21557@woody.linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

On Tue, Dec 18, 2007 at 05:19:04PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 19 Dec 2007, David Chinner wrote:
> >
> > On Tue, Dec 18, 2007 at 05:59:11PM +1100, Lachlan McIlroy wrote:
> > > Please pull from the for-linus branch:
> > >     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> > 
> > Linus, please don't pull this yet. A problem has been found in
> > the dirent fix, and we've just fixed another mknod related regression
> > so we've got another couple of fixes still to go in XFS for 2.6.24.
> 
> Too late, it's already long since pulled.

Ok, we'll just have to get the fixes to you ASAP.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
