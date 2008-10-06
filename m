Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 10:22:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m96HMNrS001766
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 10:22:23 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 278A4139EDF7
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2008 10:24:02 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id wQDoRaJD387tY34D for <xfs@oss.sgi.com>; Mon, 06 Oct 2008 10:24:02 -0700 (PDT)
Message-ID: <48EA49B1.2000500@thebarn.com>
Date: Mon, 06 Oct 2008 12:24:01 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 987159 - Fix extent list corruption in xfs_iext_irec_compact_full().
References: <20080923032821.A91D758C52AE@chook.melbourne.sgi.com> <48E8AB5A.7080301@sandeen.net> <48E8AC57.4050503@sandeen.net> <48E9631A.8050404@sgi.com>
In-Reply-To: <48E9631A.8050404@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

Mark Goodwin wrote:
>
>
> Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Lachlan McIlroy wrote:
>>
>>
>>>>     - Fix extent list corruption in xfs_iext_irec_compact_full().
>>> Are there plans to try to get this, and possibly the compact_full
>>> removal pushed into 2.6.27 still?  (and maybe even 2.6.26.x?)
>>>
>>> -Eric
>>>
>>>
>>
>> ugh already in, sorry.  ignore me!
>
> yes, already in .27, but not yet .26 as far as I know.
>
> Cheers
>
BTW can we get xfsidbg fixed up so it compiles.
Also it would be nice to add the extra debug patch into the extent list 
print function.
