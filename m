Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39067 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751382AbdJPA0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 20:26:36 -0400
Date: Mon, 16 Oct 2017 11:26:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/30] xfs: dispatch metadata scrub subcommands
Message-ID: <20171016002634.GK3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777249171.1724.12406555149699179317.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777249171.1724.12406555149699179317.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create structures needed to hold scrubbing context and dispatch incoming
> commands to the individual scrubbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
