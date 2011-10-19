Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J0oxrD143025 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 19:50:59 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58EF01C9779D
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 17:50:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4NdIU4jTr2mLzubQ for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 17:50:57 -0700 (PDT)
Date: Wed, 19 Oct 2011 11:50:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: remove the unused dm_attrs structure
Message-ID: <20111019005055.GD21338@dastard>
References: <20111018201304.279051318@bombadil.infradead.org>
	<20111018201405.736219363@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111018201405.736219363@bombadil.infradead.org>
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

On Tue, Oct 18, 2011 at 04:13:08PM -0400, Christoph Hellwig wrote:
> .. and the just as dead bhv_desc forward declaration while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
