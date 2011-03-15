Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2FGZs1V136913 for <xfs@oss.sgi.com>; Tue, 15 Mar 2011 11:36:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B18D1DEC347
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2011 09:38:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nHreeANSVCq9OoK1 for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2011 09:38:39 -0700 (PDT)
Date: Tue, 15 Mar 2011 12:38:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for February 2011
Message-ID: <20110315163836.GA10748@infradead.org>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

February saw the stabilization of the Linux 2.6.38 tree, with just two
small XFS fixes going into Linus' tree, and the XFS development tree
has been similarly quite with just a few cleanups, and the delaylog option
propagated to the default operation mode.  A few more patches for the 2.6.39
merge window have been posted and/or discussed on the mailing list, but February
was a rather quite month in general.

On the user space side xfsprogs saw a few bug fixes, and a speedup for
phase2 of xfs_repair, xfsdump saw a bug fix and support for pruning the
inventory by session id, and xfstests saw it's usual stream of bug fixes
as well as two new test cases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
