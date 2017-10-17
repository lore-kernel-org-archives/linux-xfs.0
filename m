Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:15866 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966340AbdJQV7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2017 17:59:34 -0400
Date: Wed, 18 Oct 2017 08:59:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 18/30] xfs: scrub inode btrees
Message-ID: <20171017215931.GR15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777256125.1724.12622578684332324586.stgit@magnolia>
 <20171017001117.GV4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017001117.GV4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 05:11:17PM -0700, Darrick J. Wong wrote:
> Check the records of the inode btrees to make sure that the values
> make sense given the inode records themselves.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix insane freemask variable usage, shorten helper function names

looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
