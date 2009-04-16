Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GKEvKr089264 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 15:15:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15328142924E
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 13:16:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HKiMp7mpVyAiXjw0 for
	<xfs@oss.sgi.com>; Thu, 16 Apr 2009 13:16:57 -0700 (PDT)
Date: Thu, 16 Apr 2009 16:14:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for March 2009
Message-ID: <20090416201426.GA6035@infradead.org>
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


Linux 2.6.29 has been released which includes major XFS updates like the
new generic btree code, a fully functional 32bit compat ioctl implementation
and the new combined XFS and Linux inode.  (See previous status reports
for more details). A patch series to improve correctness and performance
has been posted but not yet applied.  Various minor fixes and cleanups
have been sent to Linus for 2.6.30 which looks like it will be a minor
release for XFS after the big churn in 2.6.29.

On userspace a lot of time has been spent on fixing and improving the
build system shared by the various XFS utilities as well as various smaller
improvements leading to the xfsprogs and xfsdump 3.0.1 releases which are
still outstanding.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
