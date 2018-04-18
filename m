Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58254 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbeDRKab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 06:30:31 -0400
Date: Wed, 18 Apr 2018 03:30:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
Message-ID: <20180418103031.GC15190@infradead.org>
References: <20180418002111.11637-1-david@fromorbit.com>
 <20180418002111.11637-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418002111.11637-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
