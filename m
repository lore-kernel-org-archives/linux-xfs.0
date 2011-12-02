Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2HllKj092669 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:47:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C5454D4EE0
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:41 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kCNhSgCDYwe9ieNh for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:41 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD2-0000hY-GH
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:40 +0000
Message-Id: <20111202174619.179530033@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/12] xfs_repair queue
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

This is my current repair queue.  Many patches have been sent before,
either formally or in reply to buf reports.  Most of it are fixes
for arekm's corrupted filesystem from hell (and two fixes for it are
still missing, but I'm looking into it), two are for other bug reports
and the last three are cleanups for things I noticed while working on
the rest.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
