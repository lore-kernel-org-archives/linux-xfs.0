Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:43689
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753939AbeGCFuI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 01:50:08 -0400
Date: Tue, 3 Jul 2018 15:50:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/21] xfs: repair refcount btrees
Message-ID: <20180703055004.GI2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986828517.3155.15745367767679349376.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986828517.3155.15745367767679349376.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:24:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reconstruct the refcount data from the rmap btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Seems reasonable, though my brain turn to mush when trying to work
out the code that turned the rmap records into refcounts :/

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
