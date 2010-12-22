Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMH888l000835 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 11:08:08 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4AA01476192
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:10:06 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id YiL9YxO5CEWqDpmG for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:10:06 -0800 (PST)
Date: Wed, 22 Dec 2010 12:10:06 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101222170620.GA29117@puku.stupidest.org>
Message-ID: <alpine.DEB.2.00.1012221209150.5245@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222170620.GA29117@puku.stupidest.org>
MIME-Version: 1.0
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
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com



On Wed, 22 Dec 2010, Chris Wedgwood wrote:

> if using hw raid teach mkfs about the array geom, that coupled with
> inode64 made a huge difference in performance that last time i did
> this

When I had used XFS in the past on a 3ware 9650SE-16ML with 1TB HDDs I did
not notice any performance difference on whether you set the su/swidth/etc.

Do you have an example/of what you found?
Is it dependent on the RAID card?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
