Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51447 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751155AbeAEBlh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:41:37 -0500
Date: Fri, 5 Jan 2018 12:41:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] xfs: add scrub cross-referencing helpers for the
 refcount btrees
Message-ID: <20180105014122.GW30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398982771.18741.440105008563284269.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398982771.18741.440105008563284269.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the refcount btrees that will be used
> to cross-reference metadata against the refcountbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   19 +++++++++++++++++++
>  fs/xfs/libxfs/xfs_refcount.h |    3 +++
>  2 files changed, 22 insertions(+)

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
