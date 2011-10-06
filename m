Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96L6eN0201645 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:06:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41DE114518F1
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:13:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uvtGkaFRiDgPiF7X for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:13:28 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RBv9K-0004Bq-EG
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 21:06:38 +0000
Message-Id: <20111006210607.175284390@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 17:06:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] a couple of buffer cache cleanups
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series contains a handful of patches that tidy up various bits and
pieces in the XFS buffer cache.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
