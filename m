Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0LBRK6u013061 for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 05:27:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D56B7A60BF
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 03:27:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EQvWjmXUhJG9ZHMR for
	<xfs@oss.sgi.com>; Wed, 21 Jan 2009 03:27:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LPbEO-0003gf-QR
	for xfs@oss.sgi.com; Wed, 21 Jan 2009 11:26:48 +0000
Date: Wed, 21 Jan 2009 06:26:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Long btree pointers are still 64 bit on disk
Message-ID: <20090121112648.GA9002@infradead.org>
References: <20090121042217.GL10158@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090121042217.GL10158@disturbed>
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

Looks good and passes xfsqs for me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
