Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfBDUxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 15:53:37 -0500
Date: Mon, 4 Feb 2019 12:53:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/10] xfs: add xfs_verify_agino_or_null helper
Message-ID: <20190204205336.GC30334@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930316106.31814.17027370821230009757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930316106.31814.17027370821230009757.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:21AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new helper to check that a per-AG inode pointer is either null or
> points somewhere valid within that AG.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
