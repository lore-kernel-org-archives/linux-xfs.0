Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3B1trIZ061671 for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 20:55:53 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA7DB14AB58D
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2011 18:59:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kHNMqBPuSYgr1HQ3 for <xfs@oss.sgi.com>;
	Sun, 10 Apr 2011 18:59:11 -0700 (PDT)
Date: Mon, 11 Apr 2011 11:49:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: allow deeper symlink recursion in 005
Message-ID: <20110411014933.GN30279@dastard>
References: <20110410200332.GA29662@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110410200332.GA29662@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Apr 10, 2011 at 04:03:32PM -0400, Christoph Hellwig wrote:
> Recent kernels allow more than 40 nested symlinks, so up the limit
> to still reproduce a failure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
