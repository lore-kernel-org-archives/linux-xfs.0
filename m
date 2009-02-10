Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AK9qWb072456 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:09:52 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89D8630407F
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:09:13 -0800 (PST)
Message-Id: <1E52072E-CA98-430B-9B2F-FDD0FDD1A7A4@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090210195756.GA7569@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/2] xfs: fix error handling in xfs_log_mount
Date: Tue, 10 Feb 2009 14:09:12 -0600
References: <20090210194422.767988000@bombadil.infradead.org>
	<20090210194515.509547000@bombadil.infradead.org>
	<A482AB92-6E29-43EA-A671-43D86E041335@sgi.com>
	<20090210195756.GA7569@infradead.org>
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


On Feb 10, 2009, at 1:57 PM, Christoph Hellwig wrote:

> On Tue, Feb 10, 2009 at 01:56:31PM -0600, Felix Blyakher wrote:
>> Isn't it a reworked Lachlan's patch:
>>
>> http://oss.sgi.com/archives/xfs/2009-02/msg00175.html
>
> The patch isn't related to that one at all,

... from the implementation point of view, yes.

> but it aims to fix the
> same issue.

That's what I meant.

> Should probably get a Reported-by: tag for him,

Seems reasonable.

> if
> this is indeed the thing the original patch tried to fix.

That was my understanding. Let's Lachlan pitch in.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
