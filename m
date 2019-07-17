Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55602 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQGWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 02:22:32 -0400
Date: Tue, 16 Jul 2019 23:22:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] iomap: move internal declarations into fs/iomap/
Message-ID: <20190717062231.GB27285@infradead.org>
References: <156334313527.360395.511547592522547578.stgit@magnolia>
 <156334318826.360395.9686513875631453909.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156334318826.360395.9686513875631453909.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

On Tue, Jul 16, 2019 at 10:59:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move internal function declarations out of fs/internal.h into
> include/linux/iomap.h so that our transition is complete.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Didn't I ack this earlier?

Reviewed-by: Christoph Hellwig <hch@lst.de>
