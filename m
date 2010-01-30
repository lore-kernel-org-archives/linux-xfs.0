Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UG88lc220589 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 10:08:08 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2D4619DEC2
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:09:15 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 9ImaegxrhSHFjhQv for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:09:15 -0800 (PST)
Message-ID: <4B6459AB.7050201@sandeen.net>
Date: Sat, 30 Jan 2010 10:09:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: 219: ignore duplicates reported by	repquota
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6942@cf--amer001e--3.americas.sgi.com>
	<4B626D80.3010601@sandeen.net>
	<20100130103042.GA10337@infradead.org>
In-Reply-To: <20100130103042.GA10337@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

Christoph Hellwig wrote:
> On Thu, Jan 28, 2010 at 11:09:20PM -0600, Eric Sandeen wrote:
>> there's probably better awk to be written than this, but I think this
>> fixes it:
>>
>> Alex, you look like an awk-master, can you fix it?
> 
> No fix included..
> 

right, was asking Alex for one ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
