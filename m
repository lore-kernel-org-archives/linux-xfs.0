Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEeikc165584 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:40:44 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8C10AC006
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:40:41 -0700 (PDT)
Message-Id: <6F8D4AC9-D76A-43FC-AA5C-78C86A12E244@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090409171135.GA25303@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/2] xfs: a couple getbmap cleanups
Date: Wed, 29 Apr 2009 09:40:40 -0500
References: <20090224133858.GB15820@infradead.org>
	<9EF64CF3-FDFC-4777-94A5-7295E827ABA4@sgi.com>
	<20090409171135.GA25303@infradead.org>
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
Cc: xfs@oss.sgi.com


On Apr 9, 2009, at 12:11 PM, Christoph Hellwig wrote:

> On Mon, Apr 06, 2009 at 07:57:48PM -0500, Felix Blyakher wrote:
>> Shouldn't we set error to ENOMEM here?
>
> Yes, good catch.

Christoph, do you want to repost this patch with that change?

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
