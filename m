Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19M3sN7255107 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 16:03:54 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A494B1BF22A
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 14:05:07 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 2tkeFz5zzTkhnX5X for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2010 14:05:07 -0800 (PST)
Message-ID: <4B71DC12.9010408@sandeen.net>
Date: Tue, 09 Feb 2010 16:05:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make 204 generic
References: <4B71C8DF.1090909@sandeen.net>
	<20100209220258.GA20187@infradead.org>
In-Reply-To: <20100209220258.GA20187@infradead.org>
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
> On Tue, Feb 09, 2010 at 02:43:11PM -0600, Eric Sandeen wrote:
>> 204 can be generic.
> 
> Looks good.
> 
>> Also remove a stray _scratch_mkfs that snuck into
>> _scratch_mkfs_sized :/
> 
> Heh, that might have made the ENOSPC tests pass rather easily before..

Yeah :/

>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks,
-eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
