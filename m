Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7880 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751913AbeC0WzQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:55:16 -0400
Date: Wed, 28 Mar 2018 09:55:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/20] xfs: expose various functions to repair code
Message-ID: <20180327225514.GT18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210856701.13184.3986610182558546743.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210856701.13184.3986610182558546743.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Expose various helpers that the repair code will want to use.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

makes sense, reapir will want to insert new records into trees.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
