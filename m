Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jan 2008 08:52:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0LGqF7k017288
	for <linux-xfs@oss.sgi.com>; Mon, 21 Jan 2008 08:52:17 -0800
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3421DCB25EF
	for <linux-xfs@oss.sgi.com>; Mon, 21 Jan 2008 08:52:34 -0800 (PST)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by cuda.sgi.com with ESMTP id AFwYya3YbNw3Gg2Z for <linux-xfs@oss.sgi.com>; Mon, 21 Jan 2008 08:52:34 -0800 (PST)
Message-ID: <4794C7C0.8030207@tlinx.org>
Date: Mon, 21 Jan 2008 08:26:40 -0800
From: Linda Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Known prob: MAX_LOCK_DEPTH too low?
References: <47914FA7.1000807@tlinx.org> <1200918448.6341.5.camel@lappy>
In-Reply-To: <1200918448.6341.5.camel@lappy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-Xfs <linux-xfs@oss.sgi.com>

Peter Zijlstra wrote:
> On Fri, 2008-01-18 at 17:17 -0800, Linda Walsh wrote:
>   
>> On my x86_64 machine, I got the following message
>> in log (kern = 2.6.23.14)
>>
>> Jan 16 04:08:38 Astara kernel: BUG: MAX_LOCK_DEPTH too low!
>> Jan 16 04:08:38 Astara kernel: turning off the locking correctness 
>> validator.
>>
>> Have no idea what caused it as I found the message on my console
>> somewhat after the fact.  The system had been up over 24 hours and
>> is still running.  System still seems 'fine' (been up 3 days now),
>> so you can treat this as a "data point".
>>     
>
> Are you perhaps an XFS user?
>
>   
----
    Funny you should mention that...  yes.  However, there were no
other messages that seem to indicate that the message had anything
to do with XFS.  Nice shot in the dark.


 
