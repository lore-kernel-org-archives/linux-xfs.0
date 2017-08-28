Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37965 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdH1J0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 05:26:32 -0400
Date: Mon, 28 Aug 2017 02:26:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] xfs: ordered buffer log items are never formatted
Message-ID: <20170828092631.GC28514@infradead.org>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(I don't think the additional brace are strictly needed, but they
really help parsing the statement)
