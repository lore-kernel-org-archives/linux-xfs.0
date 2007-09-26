Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:27:34 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QHRShC029806
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:27:31 -0700
Date: Wed, 26 Sep 2007 13:27:28 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [UNSURE] Re: mkfs options for a 16x hw raid5 and xfs (mostly
 large files)
In-Reply-To: <295084.46754.qm@web32913.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709261327060.24646@p34.internal.lan>
References: <295084.46754.qm@web32913.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: b.j.smith@ieee.org
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com



On Wed, 26 Sep 2007, Bryan J. Smith wrote:

> Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
>> Still 170-200 MB/s. The command above just tunes the read ahead
>> value.
>
> Don't expect your commits to an external subsystem to be anywhere
> near as fast as software RAID in simple disk benchmarks.
>
>
> -- 
> Bryan J. Smith   Professional, Technical Annoyance
> b.j.smith@ieee.org    http://thebs413.blogspot.com
> --------------------------------------------------
>     Fission Power:  An Inconvenient Solution
>
>

So what tunables do the 9550/9650SE users utilize to achieve > 500 MiB/s 
write on HW RAID5/6?

Justin.
