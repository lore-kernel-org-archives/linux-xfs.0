Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AJjpRL071035 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 13:45:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B26B510615A
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:45:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uHGHb2UwPS94c9hU for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:45:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWyXj-0000iS-CY
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 19:45:15 +0000
Message-Id: <20090210194422.767988000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 14:44:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] 2.6.29 queue
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

Two more updates for 2.6.29, one to fix a possible oops when we're out
of memory in xfs_log_mount and one to reject swapext on swapfiles.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
