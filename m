Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2BBB29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:34:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38A80AC004
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:34:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8IeZ1NmU2mtcminw for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:34:47 -0800 (PST)
Date: Tue, 3 Dec 2013 10:34:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/18] xfs: use generic posix ACL infrastructure
Message-ID: <20131202233444.GH10988@dastard>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.194735588@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131201120656.194735588@bombadil.infradead.org>
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
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Sun, Dec 01, 2013 at 03:59:17AM -0800, Christoph Hellwig wrote:
> Also create inodes with the proper mode instead of fixing it up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup work, Christoph.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
