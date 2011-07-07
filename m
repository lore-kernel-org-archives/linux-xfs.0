Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6i9M159910 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3686452CDE
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NYLV8HE1sZhbzkMh for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPo-0003oy-Go
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:40 +0000
Message-Id: <20110707110535.205001532@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/28] patch queue for Linux 3.1, V3
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

This version addresses the review comments.  The biggest change is that
the byteswaps of constants are now moved into a different patch and
applied more broadly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
