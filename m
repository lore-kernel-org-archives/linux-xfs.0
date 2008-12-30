Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUCdjJs011691 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:39:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A25351CFB
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 04:39:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EHkek7U7qgpNXSnf for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 04:39:43 -0800 (PST)
Date: Tue, 30 Dec 2008 07:39:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: attr.5.gz placement
Message-ID: <20081230123943.GA22390@infradead.org>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

when I try a dpkg-buildpackage from the current git tree (+ Eric's
configure fix to make it build) I get attr.5.gz included in both
the attr and libattr1 package.  Any idea where in the debhelper
magic that could happen?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
