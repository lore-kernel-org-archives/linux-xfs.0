Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrRMh189822 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E36531C7C9CC
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:53:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xY6bIAzDCOf5CEaO for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 09:53:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6U-0008Cf-ES
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:26 +0000
Message-Id: <20111010165242.656850411@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/11] a couple of buffer cache cleanups V2
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

Chances from V1:
 - addressed all review comments
 - add two more patches

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
