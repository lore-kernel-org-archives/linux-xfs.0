Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Sep 2006 05:56:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8KCueaG025811
	for <xfs@oss.sgi.com>; Wed, 20 Sep 2006 05:56:43 -0700
Message-ID: <451128D8.2030704@melbourne.sgi.com>
Date: Wed, 20 Sep 2006 21:41:12 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
References: <44CAE247.6020608@sandeen.net> <4510C017.4040200@oss.sgi.com>
In-Reply-To: <4510C017.4040200@oss.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric,

We already have a large number of changes queued up for 2.6.19, I'd prefer
that we don't add any more right now unless they are bug fixes.

I've raised a pv with the patch so that it doesn't get dropped.

Thanks,

David


linux-xfs@oss.sgi.com wrote:
> Eric Sandeen wrote:
>> This gets rid of some pointless macro defines... I had a version that
>> lower-cased it all too but Nathan liked this better, and he's the man! :)
>>
>> -Eric
> 
> Hm, what was the verdict on this one?
> 
> -Eric
> 

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
