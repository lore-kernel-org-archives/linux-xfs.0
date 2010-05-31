Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6WZw178884 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F53B14678D9
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:08:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oY0X0wXaZgsjHUf8 for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:08:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xu-0000ng-TU
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:08:58 +0000
Message-Id: <20100531160727.842750532@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/17] pending patches
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

Here's my list of pending patches.  Ordering them is getting a bit
difficult as various patches that have been out of a while haven't
been commited yet.  Note that some patches require Dave's

	[PATCH] xfs: fix race in inode cluster freeing failing to stale inodes

applies first.  That patch is a clear candidate for something that
should go to Linus ASAP IHMO.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
