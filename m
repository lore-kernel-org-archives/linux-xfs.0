Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEB8if164731 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:11:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75E911CF807E
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:11:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DV4dzO8lmNfZjVLK for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:11:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LzAVA-0005J4-4J
	for xfs@oss.sgi.com; Wed, 29 Apr 2009 14:11:08 +0000
Date: Wed, 29 Apr 2009 10:11:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: release.sh, take two
Message-ID: <20090429141108.GA14578@infradead.org>
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

A new release script, now using Makepkgs to simply things.  Needs to
be run from the repository directory.

Anyone fine with commiting a copy to each of the repositories?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
