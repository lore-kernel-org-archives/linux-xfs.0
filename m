Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1E40dW028186 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 08:04:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32B2F1BE87CF
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 06:04:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RLMIIItqKsNGAx7u for
	<xfs@oss.sgi.com>; Mon, 01 Dec 2008 06:04:00 -0800 (PST)
Date: Mon, 1 Dec 2008 09:03:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for November 2008
Message-ID: <20081201140329.GA5257@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

The mainline kernel is now at 2.6.28-rc6 and includes a small number of
XFS fixes.  There have been no updates to the XFS development tree during
December.  Without new regressions that large number of changes that
missed 2.6.28 has thus stabilized to be ready for 2.6.29.  In the meantime
kernel-side development has been slow, with the only major patch set
being a wide number of fixes to the compatibility for 32 bit ioctls on
a 64 bit kernel.

In the meantime there has been a large number of commits to the user space
tree, which mostly consist of smaller fixes.  xfsprogs is getting close
to have the 3.0.0 release which will be the first full resync with the
kernel sources since the year 2005.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
