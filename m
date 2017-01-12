Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdALNxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 08:53:33 -0500
Date: Thu, 12 Jan 2017 05:53:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs_io: fix some documentation problems
Message-ID: <20170112135331.GB5756@infradead.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
 <148419040105.32674.7685382394930891385.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148419040105.32674.7685382394930891385.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 07:06:41PM -0800, Darrick J. Wong wrote:
> Describe the numberless (i.e. "reflink the whole file") behavior
> in the xfs_io help system and since the clone/dedupe ioctls were
> promoted to the VFS before XFS reflink landed, mention those in
> the manpage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
