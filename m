Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IHHPU8012009 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:17:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B70BA9A457
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 09:17:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1IAc0GCNxAU6wr39 for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 09:17:24 -0800 (PST)
Date: Sun, 18 Jan 2009 12:17:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: only run 197 on 32-bit machines
Message-ID: <20090118171723.GA12645@infradead.org>
References: <496E9A84.2060304@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496E9A84.2060304@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jan 14, 2009 at 08:08:04PM -0600, Eric Sandeen wrote:
> Don't run test 197 on 64-bit machines
> 
> If it always passes on 64 bits, this gives a false
> sense of security.  Make it obvious.

I don't think it matters, but your patch looks correct and if it helps
you in some way..


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
