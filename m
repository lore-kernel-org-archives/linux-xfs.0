Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdH1J3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 05:29:17 -0400
Date: Mon, 28 Aug 2017 02:29:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: don't log dirty ranges for ordered buffers
Message-ID: <20170828092917.GE28514@infradead.org>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
