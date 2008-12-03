Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3AveqV011354 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 04:57:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B34A1B92785
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 02:57:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id u8hMk9twJndKdX7L for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 02:57:40 -0800 (PST)
Date: Wed, 3 Dec 2008 05:57:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 14/22] remove leftovers of shared read-only support
Message-ID: <20081203105709.GA19287@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.583993000@bombadil.infradead.org>
	<20081203030128.GL18236@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203030128.GL18236@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 02:01:28PM +1100, Dave Chinner wrote:
> You can kill XFS_MOUNT_SHARED from xfs_mount.h as well.

Thanks, updated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
