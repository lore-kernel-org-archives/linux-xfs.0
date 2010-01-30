Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UG2mR4220261 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 10:02:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5976E1C92086
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:03:55 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id KGJ2cDkqQqbIbA1a for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 08:03:55 -0800 (PST)
Message-ID: <4B64586A.2080603@sandeen.net>
Date: Sat, 30 Jan 2010 10:03:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: routine to create scratch of certain size
References: <4B621D89.8070800@sandeen.net>
	<20100130101951.GA32695@infradead.org>
In-Reply-To: <20100130101951.GA32695@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jan 28, 2010 at 05:28:09PM -0600, Eric Sandeen wrote:
>> This is needed for later enospc tests to be generic
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>

...

> Looks good, the only questions is why you're using $MKFS_OPTIONS for
> extN, but not for xfs?
> 

Hm, oversight I guess.  Will test w/ that.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
