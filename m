Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45139 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdCAPhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 10:37:13 -0500
Date: Wed, 1 Mar 2017 07:37:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] nowait aio: Return if cannot get hold of i_rwsem
Message-ID: <20170301153707.GB30631@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-3-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228233610.25456-3-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
