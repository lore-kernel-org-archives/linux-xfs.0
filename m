Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 17:32:11 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAD1W3Hf004755
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 17:32:04 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6A1A1B21FF1
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 17:32:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id dccQNoyDhTpihlPi for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 17:32:02 -0800 (PST)
Message-ID: <491B7EB9.1050207@sandeen.net>
Date: Wed, 12 Nov 2008 19:11:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: last xfs_repair time?
References: <20081112224109.GC18990@pixar.com> <491B6F4C.6030506@sgi.com>
In-Reply-To: <491B6F4C.6030506@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Lars Damerow <lars@pixar.com>, xfs@oss.sgi.com

Timothy Shimmin wrote:
> Lars Damerow wrote:
>> Hi folks,
>>
>> Is it possible to query XFS for the last time xfs_repair fixed a
>> filesystem? I've been searching the man pages and haven't found anything
>> useful.
>>
>> thanks!
>> -lars
>>
>> --
>> lars r. damerow :: button pusher :: pixar animation studios
>> <lars@pixar.com>
>>
> Not that I know of.
> Barry is the repair maintainer/expert though.
> 
> --Tim
> 
> 
AFAIK it doesn't, but that'd be a neat feature - adding space for that,
and maybe date of mkfs (or mkfs version) etc might be nice too.

-Eric
