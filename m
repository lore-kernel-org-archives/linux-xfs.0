Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfBBQJN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:09:13 -0500
Date: Sat, 2 Feb 2019 08:09:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 6/6] xfs: use the latest extent at writeback delalloc
 conversion time
Message-ID: <20190202160912.GB12373@infradead.org>
References: <20190201143256.43232-1-bfoster@redhat.com>
 <20190201143256.43232-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201143256.43232-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> [hch: Call updated delalloc conversion helper.]
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

And no need to mention the minor calling convention change from me
here, or to pick up the signoff for that.
