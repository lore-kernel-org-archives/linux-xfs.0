Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Nov 2008 17:56:39 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA51uQbh026788
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 17:56:26 -0800
Message-ID: <4910FCF8.5080802@sgi.com>
Date: Wed, 05 Nov 2008 12:55:04 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.28
References: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>	 <alpine.DEB.1.10.0810302201030.3116@asgard.lang.hm> <f488382f0810302253l6e8b2705u29582f348256a91a@mail.gmail.com>
In-Reply-To: <f488382f0810302253l6e8b2705u29582f348256a91a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Steven Noonan <steven@uplinklabs.net>
Cc: david@lang.hm, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Steven Noonan wrote:
> On Thu, Oct 30, 2008 at 10:02 PM,  <david@lang.hm> wrote:
>> On Fri, 31 Oct 2008, Lachlan McIlroy wrote:
>>
>>> The following changes since commit
>>> 721d5dfe7e516954c501d5e9d0dfab379cf4241a:
>>>  Linus Torvalds (1):
>>>       Merge branch 'for-linus' of git://neil.brown.name/md
>> I am a fairly heavy user of XFS and am as eager as anyone to see cleanups
>> and improvements, but 102 commits to go into -rc3????
>>
>> David Lang
>>
> 
> I'm pretty sure these won't be accepted until 2.6.29's merge window
> opens. The merge window for 2.6.28 has closed, and due to the sheer
> number of commits, at least -one- is bound to cause a regression.

Okay, that's fine.  The tree was too unstable to request a pull any earlier
and we're still chasing some issues.  We should be well and truly ready for
2.6.29.

> 
> - Steven
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
