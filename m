Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55425 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbfFDHwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 03:52:21 -0400
Date: Tue, 4 Jun 2019 17:52:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190604075217.GW29573@dread.disaster.area>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916879404.757870.10976871618930441712.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155916879404.757870.10976871618930441712.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 03:26:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert quotacheck to use the new iwalk iterator to dig through the
> inodes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, much cleaner.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
