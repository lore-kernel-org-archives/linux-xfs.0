Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 20:24:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9A3OAaG016771
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 20:24:12 -0700
Message-ID: <452B123A.9030700@sgi.com>
Date: Tue, 10 Oct 2006 13:23:38 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs vs. lockdep
References: <452A8DE2.4000608@sandeen.net> <452ADCE9.2070402@sgi.com> <452B0E53.2070507@sandeen.net>
In-Reply-To: <452B0E53.2070507@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Vlad Apostolov wrote:
>
>> Hi Eric,
>>
>> Could you please provide some more information. What kernel, test 
>> case and call stack at the time of the crash.
>>
>> Thanks,
>> Vlad
>
> Vlad, for reference, this was a very recent FC6 test kernel, which has 
> lockdep & slab debugging on.  Oopsing is as simple as mounting & 
> umounting.  It dies in lockdep code.
>
> See also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=209062
>
> -Eric
>
Thanks Eric,

I opened a pv and I see David C. replied to your email too.

Vlad
