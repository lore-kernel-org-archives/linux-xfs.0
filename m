Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5S9sYY0020806 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 04:54:34 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 9D5931E16B1E
	for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 02:57:18 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id n5T8JX2dORYsAhsW for <xfs@oss.sgi.com>;
	Mon, 28 Jun 2010 02:57:18 -0700 (PDT)
Date: Mon, 28 Jun 2010 11:57:16 +0200
From: "Steffen Knauf" <Steffen.Knauf@gmx.net>
In-Reply-To: <20100628095028.GA13389@infradead.org>
Message-ID: <20100628095716.323400@gmx.net>
MIME-Version: 1.0
References: <20100628092948.323370@gmx.net>
	<20100628095028.GA13389@infradead.org>
Subject: Re: Kernel Panic: Assertion failed: __xfs_iflags_test(ip,
	XFS_IRECLAIMABLE), file: fs/xfs/linux-2.6/xfs_sync.c, line: 727
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
Cc: xfs@oss.sgi.com

hi,

Thanks a lot, i'll upgrade to 2.6.34.

greets

Steffen

-------- Original-Nachricht --------
> Datum: Mon, 28 Jun 2010 05:50:29 -0400
> Von: Christoph Hellwig <hch@infradead.org>
> An: Steffen Knauf <Steffen.Knauf@gmx.net>
> CC: xfs-oss <xfs@oss.sgi.com>
> Betreff: Re: Kernel Panic: Assertion failed: __xfs_iflags_test(ip, XFS_IRECLAIMABLE), file: fs/xfs/linux-2.6/xfs_sync.c, line: 727

> On Mon, Jun 28, 2010 at 11:29:48AM +0200, Steffen Knauf wrote:
> > hi,
> > 
> > Hello,
> > 
> > i have lot's of trouble with a webserver which die with a kernel panic
> every week. Perhaps someone have an idea? 
> > 
> > Linux Kernel version: 2.6.33
> 
> It's a know issue that has been fixed in -stable since.  Please upgrade
> either to the latests 2.6.33-stable release or even better to
> 2.6.34-stable.

-- 
GMX DSL: Internet-, Telefon- und Handy-Flat ab 19,99 EUR/mtl.  
Bis zu 150 EUR Startguthaben inklusive! http://portal.gmx.net/de/go/dsl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
