Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0S8dTc6111674 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 02:39:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C253EC1844
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 00:38:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id I9uhnfh4YgO9EoAB for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 00:38:47 -0800 (PST)
Date: Wed, 28 Jan 2009 03:38:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix mkfs man page typo
Message-ID: <20090128083844.GA25188@infradead.org>
References: <1232777420.13684.14.camel@verge.scott.net.au>
	<497D4F35.2050506@sx.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <497D4F35.2050506@sx.jp.nec.com>
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
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 26, 2009 at 02:50:45PM +0900, Kazuya Mio wrote:
> Hi,
>
> The period after "xfs_growfs(8)" hasn't been displayed yet by your fix.
> How about the following patch?

Looks good, I'll put this in instead of Nathan's original version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
