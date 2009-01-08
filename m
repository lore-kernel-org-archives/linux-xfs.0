Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08Ij0uB021321 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 12:45:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87C01715C4
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 10:45:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2DDkb4tBIXtO5Dz9 for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 10:45:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LKzrp-000614-Ef
	for xfs@oss.sgi.com; Thu, 08 Jan 2009 18:44:29 +0000
Message-Id: <20090108184222.244013000@bombadil.infradead.org>
Date: Thu, 08 Jan 2009 13:42:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] regression fixes for 2.6.29
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

These are the patches that fix regressions and should go into 2.6.29 ASAP.
The thid patch is also a candidate for 2.6.28-stable.

All the other patches I sent to the list over the previous week are also
small and useful enough fixes that I think they should still go into 2.6.29,
but it's not as urgent.  I'll prepare another series for those over the
weekend. 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
