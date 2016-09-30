Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37416 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbcI3HGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:06:53 -0400
Date: Fri, 30 Sep 2016 00:06:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfs/122: decrease the log update done item sizes
Message-ID: <20160930070651.GA18305@infradead.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
 <147520218943.26891.3120182590574773598.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520218943.26891.3120182590574773598.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Thu, Sep 29, 2016 at 07:23:09PM -0700, Darrick J. Wong wrote:
> Redundant fields were removed from the rmap/refcount/bmap update done
> log items, so fix the size tests.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Christoph Hellwig <hch@lst.de>
