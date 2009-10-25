Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9P71uqX091438 for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 02:01:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1401BC4FEA9
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 00:03:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jko48gXiLzTrGBQm for
	<xfs@oss.sgi.com>; Sun, 25 Oct 2009 00:03:32 -0700 (PDT)
Date: Sun, 25 Oct 2009 03:03:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsprogs 3.0.5 "release"
Message-ID: <20091025070331.GA21120@infradead.org>
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
To: xfs@oss.sgi.com, nathans@debian.org, vapier@gentoo.org, sandeen@sandeen.net

It looks like SGI rushed out a 3.0.5 xfsprogs release which contains
various half-cooked changes including additions to shared libraries
without bumping the minor version and wrong patch attributions.

I can only recommend to not pick it up for distributions and wait for a
proper release from the kernel.org trees after the full release
engineering process has finished.  The current plan is to have a release
end of Novemeber, we'll have to figure out the naming / numbering to not
clash with the SGI versions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
