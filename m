Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBBDLcXN189303 for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 07:21:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B21F14F544D
	for <xfs@oss.sgi.com>; Fri, 11 Dec 2009 05:22:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wuKtT2t4KT4MFpW0 for
	<xfs@oss.sgi.com>; Fri, 11 Dec 2009 05:22:14 -0800 (PST)
Date: Fri, 11 Dec 2009 08:22:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for November 2009
Message-ID: <20091211132213.GA22342@infradead.org>
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

November was a relatively slow month for XFS development.  The XFS tree
that is destined for the Linux 2.6.33 merge window saw a few fixes and
cleanups applied to it, and few important fixes still made it into the
last Linux 2.6.32 release candidates.  A few more patches including a
final version of the event tracing support for XFS were posted but not
reviewed yet.

On the userspace side there has been a fair amount of xfsprogs activity.
The repair speedup patches have finally been merged into the main development
branch and a couple of other fixes to the various utilities made it in, too.
The xfstests test suite saw another new regression test suite and a build
system fix up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
