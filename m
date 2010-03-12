Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2C9xe2i241619 for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 03:59:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08AB9234F09
	for <xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:01:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dWCCgMpjk7whLqf1 for
	<xfs@oss.sgi.com>; Fri, 12 Mar 2010 02:01:13 -0800 (PST)
Date: Fri, 12 Mar 2010 05:01:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: avoid blkid cache with -c /dev/null not -p
Message-ID: <20100312100113.GA15922@infradead.org>
References: <4B9530C5.30705@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B9530C5.30705@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 08, 2010 at 11:15:49AM -0600, Eric Sandeen wrote:
> From: Lukas Czerner <lczerner@redhat.com>
> 
> The addition of "-p" to blkid calls broke xfstests
> on older systems where this was not supported.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
