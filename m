Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:19734 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751690AbdJPCTT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 22:19:19 -0400
Date: Mon, 16 Oct 2017 13:19:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/30] xfs: scrub the AGI
Message-ID: <20171016021916.GS3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777254886.1724.15075712654473670561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777254886.1724.15075712654473670561.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a forgotten check to the AGI verifier, then wire up the scrub
> infrastructure to check the AGI contents.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
