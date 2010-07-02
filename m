Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62Ab96Y238761 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 05:37:09 -0500
Date: Fri, 2 Jul 2010 06:39:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsdev tree in linux-next?
Message-ID: <20100702103951.GA18369@infradead.org>
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
To: sfr@canb.auug.org.au, aelder@sgi.com, david@fromorbit.com, akpm@osdl.org
Cc: xfs@oss.sgi.com

Hi Steve,

we've got a massive backlog of over a month worth of patches that have
been reviewed on the XFS list and QAed by Dave and me but not picked up
yet into the official tree.

Can you temporarily add

	git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git for-2.6.36

to the linux-next lineup so what we can get more testing exposure?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
