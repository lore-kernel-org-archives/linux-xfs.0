Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 15:17:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6KMG7DW028254
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 15:16:18 -0700
Date: Fri, 21 Jul 2006 08:14:52 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
Message-ID: <20060721081452.B1990742@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost> <20060720171310.B1970528@wobbly.melbourne.sgi.com> <44BF8500.1010708@dgreaves.com> <20060720161121.GA26748@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060720161121.GA26748@tuatara.stupidest.org>; from cw@f00f.org on Thu, Jul 20, 2006 at 09:11:21AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>, Justin Piszcz <jpiszcz@lucidpixels.com>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

On Thu, Jul 20, 2006 at 09:11:21AM -0700, Chris Wedgwood wrote:
> On Thu, Jul 20, 2006 at 02:28:32PM +0100, David Greaves wrote:
> 
> > Does this problem exist in 2.16.6.x??
> 
> The change was merged after 2.6.16.x was branched, I was mistaken
> in how long I thought the bug has been about.
> 
> > I hope so because I assumed there simply wasn't a patch for 2.6.16 and
> > applied this 'best guess' to my servers and rebooted/remounted successfully.
> 
> Doing the correct change to 2.6.16.x won't hurt, but it's not
> necessary.

Yep.  As Chris said, 2.6.17 is the only affected kernel.  I've
fixed up the whacky html formatting and my merge error (thanks
to all for reporting those) so its a bit more readable now.

cheers.

-- 
Nathan
