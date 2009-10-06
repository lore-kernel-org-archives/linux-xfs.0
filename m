Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96KZI5x091119 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 15:35:18 -0500
Message-Id: <20091006202925.459164320@bombadil.infradead.org>
Date: Tue, 06 Oct 2009 16:29:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] XFS fixes for 2.6.32
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
To: aelder@sgi.com, xfs@oss.sgi.com, akpm@linux-foundation.org, sfr@canb.auug.org.au
Cc: linux-fsdevel@vger.kernel.org

This is my queue of reviewed patches from before or the very early merge indow
that I still haven't managed to get maintainer responses for.  Thery're
all pretty crictical sync / metadata fixes that should not miss 2.6.32.

Andrew, Stephen can you carry them in -mm/linux-next at least until the
Alex reappears?

There's also a tarball of the quilt series at:

	http://verein.lst.de/~hch/xfs/patches.xfs.tgz

I have another series of potentioal deadlock fixes that still needs a positive
review still but could also enjoy some more testing in -mm/linux-next which
I'll send out later today or tomorrow.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
