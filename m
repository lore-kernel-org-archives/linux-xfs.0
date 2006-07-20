Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 15:18:58 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KMIdDW028469
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 15:18:39 -0700
Date: Thu, 20 Jul 2006 18:18:14 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
In-Reply-To: <20060721081452.B1990742@wobbly.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0607201817450.23697@p34.internal.lan>
References: <20060718222941.GA3801@stargate.galaxy>
 <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost>
 <20060720171310.B1970528@wobbly.melbourne.sgi.com> <44BF8500.1010708@dgreaves.com>
 <20060720161121.GA26748@tuatara.stupidest.org> <20060721081452.B1990742@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Chris Wedgwood <cw@f00f.org>, David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ml@magog.se, radsaq@gmail.com

Nathan,

Does the bug only occur during a crash?

I have been running 2.6.17.x for awhile now (multiple XFS filesystems, all 
on UPS) - no issue?

Justin.


On Fri, 21 Jul 2006, Nathan Scott wrote:

> On Thu, Jul 20, 2006 at 09:11:21AM -0700, Chris Wedgwood wrote:
>> On Thu, Jul 20, 2006 at 02:28:32PM +0100, David Greaves wrote:
>>
>>> Does this problem exist in 2.16.6.x??
>>
>> The change was merged after 2.6.16.x was branched, I was mistaken
>> in how long I thought the bug has been about.
>>
>>> I hope so because I assumed there simply wasn't a patch for 2.6.16 and
>>> applied this 'best guess' to my servers and rebooted/remounted successfully.
>>
>> Doing the correct change to 2.6.16.x won't hurt, but it's not
>> necessary.
>
> Yep.  As Chris said, 2.6.17 is the only affected kernel.  I've
> fixed up the whacky html formatting and my merge error (thanks
> to all for reporting those) so its a bit more readable now.
>
> cheers.
>
> -- 
> Nathan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
