Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2ADB77FB7
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:25:07 -0600 (CST)
Message-ID: <527B94A5.20004@sgi.com>
Date: Thu, 07 Nov 2013 07:24:53 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstest failures
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard> <527A9F67.6000208@sgi.com>
	<20131107081634.GB25157@infradead.org>
In-Reply-To: <20131107081634.GB25157@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/07/13 02:16, Christoph Hellwig wrote:
> On Wed, Nov 06, 2013 at 01:58:31PM -0600, Mark Tinguely wrote:
>>
>>>> xfs/206
>>>>
>>>> 	Does not expect the ftype flag.  Didn't we change a generic
>>>> 	filter to take care of this?
>>>
>>> xfs/206 has it's own mkfs filter:
>>>
>>> http://oss.sgi.com/archives/xfs/2013-10/msg00777.html
>
> And why is this patch not merged?
>

It was never reviewed.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
