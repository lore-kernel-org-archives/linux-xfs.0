Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G617Zx248054 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 01:01:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A922E15DE09F
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 23:04:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cbe6ZzvFFfSnbl40 for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 23:04:05 -0700 (PDT)
Date: Fri, 16 Jul 2010 02:04:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Fix aio completion vs unwritten extents
Message-ID: <20100716060405.GA32712@infradead.org>
References: <20100622122144.302857146@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100622122144.302857146@bombadil.infradead.org>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

Given that this still hasn't been picked up in any other tree would
people mind if we push patches 1 and 2 through the XFS tree?

I some more changes that sit ontop of this, and it would make my
life a lot easier.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
