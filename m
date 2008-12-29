Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBT9LPVf020532 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:21:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62F281792821
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 01:21:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ci5iNp4D8RsAyPwa for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 01:21:25 -0800 (PST)
Date: Mon, 29 Dec 2008 04:21:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The
	latest stable version of the Linux kernel is".
Message-ID: <20081229092124.GA18987@infradead.org>
References: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Igor Podlesny <for.poige+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
> -- Copying several rather big files (~ 25--45 GiB) from XFS on LVM-2
> on MDraid partition to another one, I had the system rebooted both
> with 2.6.28 and 2.6.27.10 (accomplished using 2.6.24.7-rt(sic!)25). As
> you probably understand, that's the case you even can't trace where's
> the problem, at least on a desktop with GUI, not on server with plain
> text display. Although, I'm afraid even text display wouldn't had a
> chance to show anything, tracing that problem.

You don't have 4K_STACKs enabled by default, do you? 

And instead of these rants bug reports would be more useful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
