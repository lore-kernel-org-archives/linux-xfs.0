Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1M5STQ236342 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 16:05:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C97F1609CBE
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 14:07:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3do7UuMchneZVKLZ for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 14:07:12 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PNupR-0007m9-SE
	for xfs@oss.sgi.com; Wed, 01 Dec 2010 22:07:09 +0000
Message-Id: <20101201220620.340188389@bombadil.infradead.org>
Date: Wed, 01 Dec 2010 17:06:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] log recovery cleanups
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

A couple of cleanups for the log recovery code that I stumbled upon when
researching some improvements for the CRC cleanup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
