Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Sep 2006 07:34:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8KEYWaG004943
	for <xfs@oss.sgi.com>; Wed, 20 Sep 2006 07:34:32 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23CF545697F
	for <xfs@oss.sgi.com>; Wed, 20 Sep 2006 06:33:58 -0700 (PDT)
Message-ID: <45114346.8020905@sandeen.net>
Date: Wed, 20 Sep 2006 08:33:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
References: <44CAE247.6020608@sandeen.net> <4510C017.4040200@oss.sgi.com> <451128D8.2030704@melbourne.sgi.com>
In-Reply-To: <451128D8.2030704@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: xfs@oss.sgi.com

David Chatterton wrote:
> Eric,
> 
> We already have a large number of changes queued up for 2.6.19, I'd prefer
> that we don't add any more right now unless they are bug fixes.
> 
> I've raised a pv with the patch so that it doesn't get dropped.

No problem, and I'm not hung up about the change, just wondered if I should keep 
it in my patch stack or if it had been dismissed as undesirable.

Thanks,

-Eric

> Thanks,
> 
> David
> 
> 
> linux-xfs@oss.sgi.com wrote:
>> Eric Sandeen wrote:
>>> This gets rid of some pointless macro defines... I had a version that
>>> lower-cased it all too but Nathan liked this better, and he's the man! :)
>>>
>>> -Eric
>> Hm, what was the verdict on this one?
>>
>> -Eric
>>
> 
