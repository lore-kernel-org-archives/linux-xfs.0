Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36008 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:31:45 -0400
Date: Fri, 24 May 2019 09:31:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/20] xfs: make use of the l_targ field in struct xlog
Message-ID: <20190523233141.GY29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:34PM +0200, Christoph Hellwig wrote:
> Use the slightly shorter way to get at the buftarg for the log device
> wherever we can in the log and log recovery code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
