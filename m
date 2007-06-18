Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 13:59:20 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5IKxFdo030852
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 13:59:17 -0700
Message-ID: <46767384.8010309@dgreaves.com>
Date: Mon, 18 Jun 2007 12:59:00 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: XFS Tunables for High Speed Linux SW RAID5 Systems?
References: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan> <20070618000502.GU86004887@sgi.com>
In-Reply-To: <20070618000502.GU86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org

David Chinner wrote:
> On Fri, Jun 15, 2007 at 04:36:07PM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> I was wondering if the XFS folks can recommend any optimizations for high 
>> speed disk arrays using RAID5?
> 
> [sysctls snipped]
> 
> None of those options will make much difference to performance.
> mkfs parameters are the big ticket item here....

Is there anywhere you can point to that expands on this?

Is there anything raid specific that would be worth including in the Wiki?

David
