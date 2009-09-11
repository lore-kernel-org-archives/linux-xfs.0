Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8BIoJJN040176 for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 13:50:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A5EA12B1BC1
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 11:51:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZdkaxRVrug8t5XqJ for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2009 11:51:31 -0700 (PDT)
Date: Fri, 11 Sep 2009 14:51:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libdisk: use major/minor when calling dmsetup
Message-ID: <20090911185130.GA11671@infradead.org>
References: <4AAA89F4.8060708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AAA89F4.8060708@sandeen.net>
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

Looks good to me.  A library API to device mapper would be even better..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
