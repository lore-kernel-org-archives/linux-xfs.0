Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 852447F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 19:04:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 762AC30409A
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:04:30 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Va36DT1q4qxBc6Gt for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 17:04:29 -0800 (PST)
Date: Tue, 3 Dec 2013 12:03:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: refactor xfs_buf_item_format_segment
Message-ID: <20131203010310.GN10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084000.310003388@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084000.310003388@bombadil.infradead.org>
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

On Fri, Nov 29, 2013 at 12:39:21AM -0800, Christoph Hellwig wrote:
> Add two helpers to make the code more readable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Much easier to understand split out like this, so thanks
for doing that.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
