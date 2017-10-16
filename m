Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:30337 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751382AbdJPA4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 20:56:37 -0400
Date: Mon, 16 Oct 2017 11:56:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/30] xfs: create helpers to scrub a metadata btree
Message-ID: <20171016005634.GN3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777251032.1724.6214215257246712623.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777251032.1724.6214215257246712623.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create helper functions and tracepoints to deal with errors while
> scrubbing a metadata btree.

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
