Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28857 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751296AbeBWEK3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 23:10:29 -0500
Date: Fri, 23 Feb 2018 15:10:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't block on the ilock for RWF_NOWAIT
Message-ID: <20180223041026.GM7000@dastard>
References: <20180222150653.18479-1-hch@lst.de>
 <20180223000819.GJ7000@dastard>
 <20180223002242.GA4007@lst.de>
 <20180223010326.GL7000@dastard>
 <20180223020243.GA5611@lst.de>
 <20180223021916.GA5787@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180223021916.GA5787@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 23, 2018 at 03:19:16AM +0100, Christoph Hellwig wrote:
> FYI, I've pushed a iomap-locking branch to my xfs.git on how
> to start the urgent fixes (4.16-rc) in this area.  I think most
> of the additional changes in your WIP patch can be nicely rebased
> on top of that.

Ok, I'll pull that and rework my patches on top of it.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
