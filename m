Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31011 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751355AbdIAA3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 20:29:47 -0400
Date: Fri, 1 Sep 2017 10:29:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix compiler warnings
Message-ID: <20170901002944.GW10621@dastard>
References: <20170831233833.GT3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831233833.GT3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, Aug 31, 2017 at 04:38:33PM -0700, Darrick J. Wong wrote:
> Fix up all the compiler warnings that have crept in.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, warnings gone.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
