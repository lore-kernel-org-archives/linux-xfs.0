Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AFxGRt196183 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 10:59:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4466ACF6CF
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 08:59:15 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	O19if1AixlF7kp0r for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 08:59:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QrBBa-0001Hk-IO
	for xfs@oss.sgi.com; Wed, 10 Aug 2011 15:59:14 +0000
Date: Wed, 10 Aug 2011 11:59:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [RFC] remove subdirectories under fs/xfs/
Message-ID: <20110810155914.GA4901@infradead.org>
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

How do people like the approach in

	http://git.kernel.org/?p=linux/kernel/git/hch/xfs.git;a=shortlog;h=refs/heads/xfs-rename

?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
