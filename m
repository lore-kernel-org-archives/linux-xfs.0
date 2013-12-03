Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B118D7F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 19:10:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4809DAC00C
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:10:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	duEjrwifD7M4SeFu for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 17:10:37 -0800 (PST)
Date: Tue, 3 Dec 2013 12:10:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: refactor xfs_inode_item_format
Message-ID: <20131203011031.GP10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084000.669357715@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084000.669357715@bombadil.infradead.org>
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

On Fri, Nov 29, 2013 at 12:39:23AM -0800, Christoph Hellwig wrote:
> Split out a function to handle the data and attr fork, as well as a helper
> for the really old v1 inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
