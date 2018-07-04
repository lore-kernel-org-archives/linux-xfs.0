Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932853AbeGDCXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 22:23:08 -0400
Date: Tue, 3 Jul 2018 19:23:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/21] xfs: repair refcount btrees
Message-ID: <20180704022305.GC32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986828517.3155.15745367767679349376.stgit@magnolia>
 <20180703055004.GI2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703055004.GI2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 03:50:04PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:24:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Reconstruct the refcount data from the rmap btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Seems reasonable, though my brain turn to mush when trying to work
> out the code that turned the rmap records into refcounts :/

Ok, thanks for the review!  Enjoy your vacation if I don't make it back
on here before you go. :)

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
