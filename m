Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAiVh2196087 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:44:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F084B1E33240
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:47:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uyZQJPveNM6rddLJ for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:47:33 -0700 (PDT)
Date: Fri, 23 Jul 2010 06:47:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4k sector drives
Message-ID: <20100723104733.GA12413@infradead.org>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
	<4C497233.8000401@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C497233.8000401@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 05:42:59AM -0500, Stan Hoeppner wrote:
> FWIW, for comparison, my 500GB Blue series WD5000AAKS-00V1A0 shows
> 
> logical_block_size	512
> physical_block_size	512
> alignment_offset	0

Which means there is absolutely no visible 4k sector support.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
