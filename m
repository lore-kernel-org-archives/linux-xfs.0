Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CKeLLU097494 for <xfs@oss.sgi.com>; Tue, 12 May 2009 15:40:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7867827F233
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 13:40:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ilvi6Knp7RV8sJ0m for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 13:40:28 -0700 (PDT)
Date: Tue, 12 May 2009 16:40:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for April 2009
Message-ID: <20090512204027.GA2973@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org


In April development for Linux 2.6.30 was in full motion.  A patchset
to correct flushing of delayed allocations with near full filesystems
has been committed in early April, as well as various smaller fixes.
A patch series to improve the behavior of sys_sync has been posted
but is waiting for VFS changes queued for Linux 2.6.31.

On the userspace side xfsprogs and xfsdump 3.0.1 have managed to split their
release dates into May again after a lot of last-minute build system updates.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
