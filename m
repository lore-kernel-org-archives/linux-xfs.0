Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UFP50C081308 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 10:25:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3D8F14280E6
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:25:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FKo4pZyvGvoIpuyd for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:25:53 -0700 (PDT)
Date: Thu, 30 Jul 2009 11:25:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH (trivial)] xfs_db: remove "-f" option from freesp usage()
Message-ID: <20090730152552.GA27914@infradead.org>
References: <4A705C6A.5010603@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A705C6A.5010603@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 29, 2009 at 09:27:54AM -0500, Eric Sandeen wrote:
> the freesp doesn't support "-f" so take it out of the usage().
> 
> The manpage is fine; usage() is the only reference to "-f"

Looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
