Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:26097 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753289AbeAJANJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 19:13:09 -0500
Date: Wed, 10 Jan 2018 11:12:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 13/21] xfs: introduce scrubber cross-referencing stubs
Message-ID: <20180110001252.GQ16421@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985228.18741.6364419677377927534.stgit@magnolia>
 <20180109210012.GH5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109210012.GH5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 01:00:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some stubs that will be used to cross-reference metadata records.
> The actual cross-referencing will be filled in by subsequent patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: move the OFLAG_CORRUPT checks into the helpers to clean up the call sites
> ---

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
