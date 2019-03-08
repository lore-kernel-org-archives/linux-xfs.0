Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfCHIJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Mar 2019 03:09:49 -0500
Date: Fri, 8 Mar 2019 00:09:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/23] xfs_io: statx -r should print attributes_mask
Message-ID: <20190308080948.GC22834@infradead.org>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
 <155148282721.16677.1887535657277622825.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155148282721.16677.1887535657277622825.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 01, 2019 at 03:27:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're dumping the raw structure, so we ought to dump everything,
> including the attributes_mask field.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
