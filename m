Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ADA27F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 19:06:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAD72AC004
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:06:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nlqzIAO1HExY6Um1 for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 17:06:11 -0800 (PST)
Date: Tue, 3 Dec 2013 12:06:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/10] xfs: refactor xfs_inode_item_size
Message-ID: <20131203010604.GO10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084000.509159807@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084000.509159807@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:39:22AM -0800, Christoph Hellwig wrote:
> Split out two helpers to size the data and attribute to make the
> function more readable.
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
