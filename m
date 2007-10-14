Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Oct 2007 15:34:04 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9EMXqM9018524
	for <linux-xfs@OSS.SGI.com>; Sun, 14 Oct 2007 15:33:54 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1Ih3nb-0002Pu-4J
	for <linux-xfs@OSS.SGI.com>; Sun, 14 Oct 2007 14:46:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18194.7606.548806.972422@base.ty.sabi.co.UK>
Date: Sun, 14 Oct 2007 14:46:30 +0100
Subject: Re: Repeated XFS Crash on x86_64 fiesty
In-Reply-To: <471209D0.9090305@openenterprise.co.uk>
References: <470F2A1E.9070503@openenterprise.co.uk>
	<Pine.LNX.4.64.0710121551470.16962@p34.internal.lan>
	<471209D0.9090305@openenterprise.co.uk>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Sun, 14 Oct 2007 13:21:36 +0100, Nick Gregory
>>> <nick@openenterprise.co.uk> said:

nick> [ ... ] Shortly after my posting I had a drive fail shortly
nick> followed by another three taking out 6TB of data :-( ,
nick> luckily part of a replicated pair. So its certainly a
nick> hardware thing either a bad raid card or a bad batch of
nick> drives rather than anything to do with XFS.

Multiple drive failures are somewhat more common than desirable,
and RAID is based on the idea that failures are uncorrelated.

But then I have seen storage systems where all the drives were
of the same brand, model and even had nearly consecutive serial
numbers, and of course got delivered at the same time, and never
mind that all these drives end up all in the same rack, with the
same cooling and power circuit and get started and stopped at
the same times.

For my home PC I have 4 drives of different brands, models,
ordered at different times from different shops, and the backups
are in external cases that are usually unconnected and unplugged
from mains. Can't be too careful :-).
