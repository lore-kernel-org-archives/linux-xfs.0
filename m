Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:8315 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752517AbeAFUqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jan 2018 15:46:49 -0500
Date: Sun, 7 Jan 2018 07:46:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 08/21] xfs: add scrub cross-referencing helpers for
 the rmap btrees
Message-ID: <20180106204645.GD30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398982164.18741.14153975836991113575.stgit@magnolia>
 <20180105215339.GL5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180105215339.GL5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 05, 2018 at 01:53:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the rmap btrees that will be used
> to cross-reference metadata against the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: expand documentation to clarify the behavior of _record_exists

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
