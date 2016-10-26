Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51645 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753093AbcJZKXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:23:08 -0400
Date: Wed, 26 Oct 2016 03:23:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/39] xfs: define the on-disk refcount btree format
Message-ID: <20161026102306.GC29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743663655.11035.6044942751505512619.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743663655.11035.6044942751505512619.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> [hch: allocate the cursor with KM_NOFS to quiet lockdep]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I don't remember touching any of this, though :)
