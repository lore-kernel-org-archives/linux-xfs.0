Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732409AbeGaRQ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 13:16:59 -0400
Subject: Re: [PATCH] misc: remove COPYING from doc/ Makefile
References: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
 <20180731074313.GA19990@infradead.org> <20180731080646.GF2234@dastard>
 <20180731080825.GA16028@infradead.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <00916b67-50bf-18b0-72b5-004f546659f0@redhat.com>
Date: Tue, 31 Jul 2018 10:36:05 -0500
MIME-Version: 1.0
In-Reply-To: <20180731080825.GA16028@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 7/31/18 3:08 AM, Christoph Hellwig wrote:
> On Tue, Jul 31, 2018 at 06:06:46PM +1000, Dave Chinner wrote:
>> Sorry, what? I added that as part of my spdx conversion patch. That
>> patch also removed the COPYING file.
>>
>> How did these changes get merged? I sent a pull request to convert
>> everything in xfsprogs and that had all the correct conversions and
>> documentation in it. here's the pull request:
>>
>> https://marc.info/?l=linux-xfs&m=152948738523911&w=2
>>
>> and you can see from the diffstat it did all this stuff...
> 
> Ok.  I looked for license info in master but that didn't have the
> whole conversion.  That master vs for-next think in the userspace
> tools keeps on confusing me..
> 

Sorry about that.

I can rethink it if needed, when I started this gig I was keeping
everything in rebaseable for-next because I feared egregious mistakes.
That's still possible but I'd like to think I'm a little better at it now ;)

-Eric
