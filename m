Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HFohdI026272 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 09:50:43 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E58F1C57B05
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 07:51:41 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id TlPYsEm5r5NC1QH0 for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 07:51:41 -0800 (PST)
References: <4B51220F.7020703@sandeen.net>
	<20100117114344.GC7813@infradead.org>
Message-Id: <ADDE5B69-77DD-4F21-9F1D-25255D50DAEC@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20100117114344.GC7813@infradead.org>
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] xfstests 131: kill locktest process in cleanup & better
	error msgs
Date: Sun, 17 Jan 2010 09:51:40 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Jan 17, 2010, at 5:43 AM, Christoph Hellwig <hch@infradead.org>  
wrote:

>
> Might be worth using herror or hsterror, although the manpage marks  
> them
> as obsolete..
>
Yeah didn't use them for that reason, no idea why they're obsoleted...

Thanks,
Eric

> Anyway, good enough to put in, so:
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
