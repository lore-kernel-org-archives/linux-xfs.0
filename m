Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9343 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbeABXLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 18:11:36 -0500
Date: Wed, 3 Jan 2018 10:11:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/20] xfs: remove XFS_FSB_SANITY_CHECK
Message-ID: <20180102231132.GW5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399122992.23543.9403402573788285274.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399122992.23543.9403402573788285274.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:07:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We already have a function to verify fsb pointers, so get rid of the
> last users of the (less robust) macro.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Nice little cleanup :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
