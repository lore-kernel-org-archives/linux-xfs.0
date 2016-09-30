Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbcI3I2K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:28:10 -0400
Date: Fri, 30 Sep 2016 01:28:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 61/63] xfs: various swapext cleanups
Message-ID: <20160930082809.GN32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520513969.29434.6906497983480048097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520513969.29434.6906497983480048097.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:12:19PM -0700, Darrick J. Wong wrote:
> Replace structure typedefs with struct expressions and fix some
> whitespace issues that result.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
