Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22765 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751704AbdKLXRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Nov 2017 18:17:39 -0500
Date: Mon, 13 Nov 2017 10:14:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH for 4.15] xfs_io: pull xfs errortag definitions from
 libxfs
Message-ID: <20171112231443.GH5858@dastard>
References: <20171111014314.GD25227@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171111014314.GD25227@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 10, 2017 at 05:43:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the libxfs definitions, don't provide our own.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, will fix the merge problem I mentioned on #xfs.:)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
