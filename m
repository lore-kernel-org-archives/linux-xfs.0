Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBV292jh020688 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 20:09:02 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76C4C54068
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 18:09:01 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id yl6relELY4abwT35 for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 18:09:01 -0800 (PST)
Message-ID: <495AD43B.8050105@sandeen.net>
Date: Tue, 30 Dec 2008 20:08:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] xfstests: update for xfs_dinode_core_t removal
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230913.139390000@bombadil.infradead.org>
In-Reply-To: <20081230230913.139390000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> Strip away the core. prefixes in 186 to make sure the golden output
> works for both old and new xfsprogs.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
