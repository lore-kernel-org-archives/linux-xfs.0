Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38316 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfBDU7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 15:59:30 -0500
Date: Mon, 4 Feb 2019 12:59:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: add tracepoints for high level iunlink
 operations
Message-ID: <20190204205930.GH30334@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930319873.31814.12430374692247625444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930319873.31814.12430374692247625444.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:58AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add tracepoints so we can associate high level operations with low level
> updates.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
