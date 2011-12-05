Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB54SOvE110471 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:28:24 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AD1C4D820B
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:28:11 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YD23TnvRN2VUbgO7 for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:28:11 -0800 (PST)
Date: Mon, 5 Dec 2011 15:12:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: cleanup dquot locking helpers
Message-ID: <20111205041246.GL7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.096938133@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082837.096938133@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:27AM -0500, Christoph Hellwig wrote:
> Mark the trivial lock wrappers as inline, and make the naming consistent
> for all of them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
