Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81LbC6p209103 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 16:37:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D89193040C0
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 14:38:08 -0700 (PDT)
Message-Id: <BCD25157-D5FB-4B32-B6C1-BA44A3F831A4@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090901201329.GA14400@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs: actually enable the swapext compat handler
Date: Tue, 1 Sep 2009 16:22:54 -0500
References: <20090901180308.GA26071@infradead.org>
	<4A9D79F7.9080702@sandeen.net>
	<20090901201329.GA14400@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Sep 1, 2009, at 3:13 PM, Christoph Hellwig wrote:

> On Tue, Sep 01, 2009 at 02:45:59PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> Fix a small typo in the compat ioctl handler that cause the swapext
>>> compat handler to never be called.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Torsten Kaiser <just.for.lkml@googlemail.com>
>>> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
>>
>> Guilty-party: Eric Sandeen <sandeen@sandeen.net>
>> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Yep, trivial fix. Looks good.
Reviewed-by: Felix Blyakher <felixb@sgi.com>

>>
>
> Haha, thanks.  Felix, can you push this one to Linus for 2.6.31?

Sure, doing it now.

Felix

>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
