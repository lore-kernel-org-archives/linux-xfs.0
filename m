Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CJKu81079407 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:20:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97BDA1923D2E
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 11:20:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id c7nnVzduzTA0BvXP for
	<xfs@oss.sgi.com>; Thu, 12 Feb 2009 11:20:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LXh6E-0008A1-QI
	for xfs@oss.sgi.com; Thu, 12 Feb 2009 19:19:50 +0000
Date: Thu, 12 Feb 2009 14:19:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] 2.6.29 queue
Message-ID: <20090212191950.GA27823@infradead.org>
References: <20090210194422.767988000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210194422.767988000@bombadil.infradead.org>
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

On Tue, Feb 10, 2009 at 02:44:22PM -0500, Christoph Hellwig wrote:
> Two more updates for 2.6.29, one to fix a possible oops when we're out
> of memory in xfs_log_mount and one to reject swapext on swapfiles.

Thanks for the reviews!

The patches are now available to pull from:

		git://git.kernel.org/pub/scm/fs/xfs/xfs.git
	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
