Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56166 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388618AbfEWWb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:31:28 -0400
Date: Fri, 24 May 2019 08:31:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/20] xfs: remove the no-op spinlock_destroy stub
Message-ID: <20190523223124.GN29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:23PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_linux.h | 2 --
>  fs/xfs/xfs_log.c   | 2 --
>  2 files changed, 4 deletions(-)

Simple enough :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
