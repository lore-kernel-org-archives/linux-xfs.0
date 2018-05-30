Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55974 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932408AbeE3Xqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:46:39 -0400
Date: Thu, 31 May 2018 09:46:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/13] xfs: use iomap_bmap
Message-ID: <20180530234637.GJ10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:12AM +0200, Christoph Hellwig wrote:
> Switch to the iomap based bmap implementation to get rid of one of the
> last users of xfs_get_blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
