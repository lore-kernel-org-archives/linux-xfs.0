Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfDCOoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Apr 2019 10:44:44 -0400
Date: Wed, 3 Apr 2019 07:44:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: clarify that bio_add_page() and related helpers
 can add multi pages
Message-ID: <20190403144443.GA8397@infradead.org>
References: <20190402023632.8485-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402023632.8485-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
