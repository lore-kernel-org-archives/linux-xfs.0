Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f173.google.com ([209.85.219.173]:39364 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbfFMJLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 05:11:14 -0400
Received: by mail-yb1-f173.google.com with SMTP id y17so233758ybm.6
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 02:11:13 -0700 (PDT)
Subject: Re: alternative take on the same page merging leak fix
References: <20190611151007.13625-1-hch@lst.de>
 <20190612010922.GA17522@ming.t460p> <20190612074527.GA20491@lst.de>
 <20190612101111.GA16000@ming.t460p>
 <5d781312-d28e-5bcc-4294-27facdd4a1e7@kernel.dk>
 <20190613090257.GA13708@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d0eb5ef0-4cb0-d2c0-7f5a-12830e916672@kernel.dk>
Date: Thu, 13 Jun 2019 03:11:08 -0600
MIME-Version: 1.0
In-Reply-To: <20190613090257.GA13708@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On 6/13/19 3:02 AM, Christoph Hellwig wrote:
> On Thu, Jun 13, 2019 at 03:02:10AM -0600, Jens Axboe wrote:
>>>> Patches 3 and 4 have no dependencies on 1 and 2, and should have
>>>> arguably been ordered first in the series.
>>>
>>> OK, that is good to make patch 3 &4 into 5.2, I will give a review
>>> soon.
>>
>> I'll echo Mings sentiments here, for the series.
> 
> And what does that actually mean?  Do you want me to just resend
> 3 and 4, or can you just pick them up?

Please resend them with the acks/reviews, I'll pick them up asap.

-- 
Jens Axboe
