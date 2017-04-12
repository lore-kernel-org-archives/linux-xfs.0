Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39079 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753233AbdDLIhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 04:37:04 -0400
Date: Wed, 12 Apr 2017 01:37:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] nowait aio: Return -EOPNOTSUPP if filesystem does
 not support
Message-ID: <20170412083704.GC22363@infradead.org>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-10-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411142619.27205-10-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

This should go into the patch that introduces IOCB_NOWAIT.
