Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Apr 2007 09:41:51 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3SGfhfB008799
	for <xfs@oss.sgi.com>; Sat, 28 Apr 2007 09:41:44 -0700
Date: Sat, 28 Apr 2007 12:41:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS on x86_64 Linux Question
In-Reply-To: <p73lkgc1k2s.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0704281241100.11586@p34.internal.lan>
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
 <p73lkgc1k2s.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>, linux-raid@linux-kernel.vger.kernel.org



On Sat, 28 Apr 2007, Andi Kleen wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>
>> Had a quick question, if I re-provision a host with an Intel Core Duo
>> CPU with x86_64 Linux; I create a software raid array and use the XFS
>> filesystem-- all in 64bit space...
>>
>> If I boot a recovery image such as Knoppix, it will not be able to
>> work on the filesystem correct?  I would need a 64bit live CD?
>
> There used to be a XFS bug that 32bit journals couldn't
> be replayed on 64bit and vice versa. This means you couldn't mount
> a dirty file system on the other architecture. But this bug has been
> long fixed and mounting clean file systems always worked.
>
> -Andi
>

Thanks for the prompt reply!  I have more confidence in trying x86_64 now 
:)

Justin.
