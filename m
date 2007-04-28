Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Apr 2007 05:09:57 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3SC9sfB009720
	for <xfs@oss.sgi.com>; Sat, 28 Apr 2007 05:09:55 -0700
Date: Sat, 28 Apr 2007 08:09:53 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS on x86_64 Linux Question
In-Reply-To: <5d96567b0704280457t464e5c3fm81a9e22a5608751@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704280809460.7998@p34.internal.lan>
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
 <Pine.LNX.4.64.0704280636220.7998@p34.internal.lan>
 <5d96567b0704280457t464e5c3fm81a9e22a5608751@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org

Wow, probably better to stick with 32bit then?

On Sat, 28 Apr 2007, Raz Ben-Jehuda(caro) wrote:

> Justin hello
> I have tested 32 to 64 bit porting of linux raid5 and xfs and LVM
> it worked. though i cannot say I have tested throughly. it was a POC.
>
> On 4/28/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> With correct CC'd address.
>> 
>> 
>> On Sat, 28 Apr 2007, Justin Piszcz wrote:
>> 
>> > Hello--
>> >
>> > Had a quick question, if I re-provision a host with an Intel Core Duo CPU
>> > with x86_64 Linux; I create a software raid array and use the XFS
>> > filesystem-- all in 64bit space...
>> >
>> > If I boot a recovery image such as Knoppix, it will not be able to work 
>> on
>> > the filesystem correct?  I would need a 64bit live CD?
>> >
>> > Does the same apply to software raid?  Can I mount a software raid 
>> created in
>> > a 64bit environment in a 32bit environment?
>> >
>> > Justin.
>> >
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
>
> -- 
> Raz
>
