Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PA2dF6048204 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:02:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9626188EEA
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 02:03:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Di0iyR548HGUFE0d for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 02:03:43 -0800 (PST)
Date: Mon, 25 Jan 2010 05:03:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] repair: add missing newlines to scan.c
Message-ID: <20100125100343.GA22748@infradead.org>
References: <4B5B66F5.7060608@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B5B66F5.7060608@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Jan 23, 2010 at 03:15:33PM -0600, Eric Sandeen wrote:
> Commit c83b756da0dac727457022d88d2a0ace30a6dc09 added some new
> do_warn's but omitted the "\n" leading to some pretty messy
> output when we go down this path.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
