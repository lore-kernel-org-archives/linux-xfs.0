Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 09:12:17 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6KGBkDW022750
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 09:11:52 -0700
Date: Thu, 20 Jul 2006 09:11:21 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: FAQ updated (was Re: XFS breakage...)
Message-ID: <20060720161121.GA26748@tuatara.stupidest.org>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost> <20060720171310.B1970528@wobbly.melbourne.sgi.com> <44BF8500.1010708@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44BF8500.1010708@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: Nathan Scott <nathans@sgi.com>, Kasper Sandberg <lkml@metanurb.dk>, Justin Piszcz <jpiszcz@lucidpixels.com>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

On Thu, Jul 20, 2006 at 02:28:32PM +0100, David Greaves wrote:

> Does this problem exist in 2.16.6.x??

The change was merged after 2.6.16.x was branched, I was mistaken
in how long I thought the bug has been about.

> I hope so because I assumed there simply wasn't a patch for 2.6.16 and
> applied this 'best guess' to my servers and rebooted/remounted successfully.

Doing the correct change to 2.6.16.x won't hurt, but it's not
necessary.
