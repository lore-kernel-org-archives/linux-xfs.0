Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:38:42 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QHcXDo000585
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:38:34 -0700
Date: Wed, 26 Sep 2007 13:38:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [UNSURE] Re: mkfs options for a 16x hw raid5 and xfs (mostly
 large files)
In-Reply-To: <Pine.LNX.4.64.0709261336080.24646@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0709261338270.24646@p34.internal.lan>
References: <957634.8098.qm@web32915.mail.mud.yahoo.com>
 <Pine.LNX.4.64.0709261336080.24646@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Bryan J. Smith" <b.j.smith@ieee.org>
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com



On Wed, 26 Sep 2007, Justin Piszcz wrote:

>
>
> On Wed, 26 Sep 2007, Bryan J. Smith wrote:
>
>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>> So what tunables do the 9550/9650SE users utilize to achieve > 500
>>> MiB/s write on HW RAID5/6?
>> 
>> Don't know.  But I've never claimed it was capable of it either.
>> 
>> At the same time, I've seen software RAID do over 500MBps, only to
>> drop to under 50MBps aggregate client DTR under load.
>
> Do you have any type of benchmarks to similate the load you are mentioning? 
> What did HW RAID drop to when the same test was run with SW RAID / 50 MBps 
> under load?  Did it achieve better performance due to an on-board / raid-card 
> controller cache, or?
>
> Justin.
>
>

simulate* rather.
