Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EDBheg000639 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 08:11:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E25E416129F5
	for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 06:19:15 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vcroY3hykvizHLDE for <xfs@oss.sgi.com>;
	Fri, 14 Oct 2011 06:19:15 -0700 (PDT)
Date: Fri, 14 Oct 2011 09:11:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for September 2011
Message-ID: <20111014131142.GA997@infradead.org>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

August saw further release candidates of Linux 3.1, which had been
completely uneventful with just a single small regression fix being
merged.

In the meantime developments for the Linux 3.2 kernel went on with the merge
of a large series that completely refactors the XFS-internal xfs_bmapi
interfaces for simpler interfaces and less stack usage, as well as various
smaller cleanups and fixes.

September also was a very busy month for userspace development. In xfsprogs
we saw various error handling fixes to libxcmd, libxfs, mkfs.xfs, xfs_quota
and xfs_repair, xfsdump saw a few smaller changes finishing up the large
work done in August.  Xfstests saw 4 new test cases contributed from
various developers, and the usual handful of bug fixes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
