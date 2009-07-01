Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61G9Wtp021226 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 11:09:32 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68080AC011
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 09:10:00 -0700 (PDT)
Message-Id: <708E7D36-A57F-4ABD-935C-6AF6524E364B@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A48D218.5050208@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] add more statics & drop some unused functions
Date: Wed, 1 Jul 2009 11:10:01 -0500
References: <4A1C3D65.4020306@sandeen.net>
	<20090527102319.GA28274@infradead.org>
	<4A48D218.5050208@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>


On Jun 29, 2009, at 9:39 AM, Eric Sandeen wrote:

> Christoph Hellwig wrote:
>> On Tue, May 26, 2009 at 02:05:09PM -0500, Eric Sandeen wrote:
>>> A lot more functions could be made static, but they need
>>> forward declarations; this does some easy ones, and also
>>> found a few unused functions in the process.
>>
>> Looks good to me.
>>
>
> Felix, do you plan to merge this one?

Yep, will merge and push it to oss shortly.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
