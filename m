Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 18:12:54 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAD2Cljw008108
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:12:47 -0800
Date: Thu, 13 Nov 2008 13:16:00 +1100
Subject: Re: last xfs_repair time?
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20081112224109.GC18990@pixar.com> <491B6F4C.6030506@sgi.com>
 <491B7EB9.1050207@sandeen.net>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ukjcky143jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <491B7EB9.1050207@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>
Cc: Lars Damerow <lars@pixar.com>, xfs@oss.sgi.com

On Thu, 13 Nov 2008 12:11:21 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Timothy Shimmin wrote:
>> Lars Damerow wrote:
>>> Hi folks,
>>>
>>> Is it possible to query XFS for the last time xfs_repair fixed a
>>> filesystem? I've been searching the man pages and haven't found  
>>> anything
>>> useful.
>>>
>>> thanks!
>>> -lars
>>>
>>> --
>>> lars r. damerow :: button pusher :: pixar animation studios
>>> <lars@pixar.com>
>>>
>> Not that I know of.
>> Barry is the repair maintainer/expert though.
>>
>> --Tim
>>
>>
> AFAIK it doesn't, but that'd be a neat feature - adding space for that,
> and maybe date of mkfs (or mkfs version) etc might be nice too.
>
> -Eric

That would sort of fall under the last repair logs still on the todo list.
