Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 May 2007 13:35:35 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l45KZSfB010426
	for <xfs@oss.sgi.com>; Sat, 5 May 2007 13:35:29 -0700
Date: Sat, 5 May 2007 13:35:25 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS crash on linux raid
Message-ID: <20070505203525.GA16477@tuatara.stupidest.org>
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <463B4962.70904@sandeen.net> <20070504173049.14606033@harpe.intellique.com> <20070504232028.GA19744@tuatara.stupidest.org> <20070505171931.6fe9b6f5@galadriel.home> <463CB5C4.7040803@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463CB5C4.7040803@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com

On Sat, May 05, 2007 at 11:50:12AM -0500, Eric Sandeen wrote:

> There are also stack debugging config options; one that will warn if
> you are about to overflow (CONFIG_DEBUG_STACKOVERFLOW) and one that
> will print max stack depth in sysrq-t output
> (CONFIG_DEBUG_STACK_USAGE).

I was in such a hurry I don't think I tweaked that sanely.  I'll go
over the patch checking that and test it later today.

Is there some preferred kernel version people would like?
