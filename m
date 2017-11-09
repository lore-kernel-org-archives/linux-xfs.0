Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19151 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754687AbdKIXeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 18:34:21 -0500
Date: Fri, 10 Nov 2017 10:25:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/5] xfs: remove u_int* type usage
Message-ID: <20171109232525.GR4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <20171109173547.GM26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109173547.GM26910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Thu, Nov 09, 2017 at 09:35:47AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the uint* types instead of the u_int* types.  This will (hopefully)
> pair with an xfsprogs cleanup.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
