Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47201 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbfFDCXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 22:23:20 -0400
Date: Tue, 4 Jun 2019 12:23:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/20] xfs: factor out iclog size calculation from
 xlog_sync
Message-ID: <20190604022316.GO29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:34PM +0200, Christoph Hellwig wrote:
> Split out another self-contained bit of code from xlog_sync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much easier on the eyes. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
