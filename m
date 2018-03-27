Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29658 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751913AbeC0Wyn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:54:43 -0400
Date: Wed, 28 Mar 2018 09:54:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/20] xfs: add helpers to calculate btree size
Message-ID: <20180327225436.GS18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210856079.13184.1799495382406633140.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210856079.13184.1799495382406633140.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a bunch of helper functions that calculate the sizes of various
> btrees.  These will be used to repair btrees and btree headers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

simple enough

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
