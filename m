Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbeEVKKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 06:10:18 -0400
Date: Tue, 22 May 2018 03:10:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/12] xfs: convert to bioset_init()/mempool_init()
Message-ID: <20180522101016.GD4477@infradead.org>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-12-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180520222558.7053-12-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com

This creates a minor conflict with my iomap series, but that should
be easy to merge if needed.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
