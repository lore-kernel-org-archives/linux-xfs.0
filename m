Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15423 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750759AbdJPENZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 00:13:25 -0400
Date: Mon, 16 Oct 2017 15:13:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 23/30] xfs: scrub directory/attribute btrees
Message-ID: <20171016041322.GZ3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777259255.1724.8260042630662084376.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777259255.1724.8260042630662084376.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>

On Wed, Oct 11, 2017 at 06:43:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Provide a way to check the shape and scrub the hashes and records
> in a directory or extended attribute btree.  These are helper functions
> for the directory & attribute scrubbers in subsequent patches.

looks good

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
