Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p027W1xM202118 for <xfs@oss.sgi.com>; Sun, 2 Jan 2011 01:32:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C4F122D38E
	for <xfs@oss.sgi.com>; Sat,  1 Jan 2011 23:34:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QkjDO9gjZDWUDRQt for
	<xfs@oss.sgi.com>; Sat, 01 Jan 2011 23:34:07 -0800 (PST)
Date: Sun, 2 Jan 2011 02:34:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for December 2010
Message-ID: <20110102073405.GA32611@infradead.org>
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
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

The release process of the Linux 2.6.37 kernel with it's large XFS updates
was in it's final days in December, which explains why we only saw a single
one-liner regression fix for XFS in Linus' tree.  The XFS development tree
finally saw some updates when the writeback updates and some small cleanups
to the allocator and log recovery code were merged, but the large metadata
scalability updates that have been posted to the list multiple times are
still missing.  In addition to this on-going work the list also saw patches
that fix smaller issues, which are also still waiting to be merged.

On the userspace side xfsprogs and xfsdump development has been quit, with
no commits to either repository in December, although a large series of
updates to the metadump command has been reposted near the end of the month.
The xfstests repository saw a new regression test for a btrfs problem,
and various updates to existing tests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
