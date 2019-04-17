Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50296 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfDQWzf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 18:55:35 -0400
Date: Thu, 18 Apr 2019 08:55:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: kill the xfs_dqtrx_t typedef
Message-ID: <20190417225533.GW29573@dread.disaster.area>
References: <20190417224306.GC5072@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417224306.GC5072@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 17, 2019 at 03:43:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's only a few uses left, so just kill the typedef while we're at
> it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yay! LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
