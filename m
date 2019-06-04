Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:34650 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbfFDAZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 20:25:30 -0400
Date: Tue, 4 Jun 2019 10:25:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: finish converting to inodes_per_cluster
Message-ID: <20190604002526.GL29573@dread.disaster.area>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
 <155960229217.1194435.2177246831746410691.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155960229217.1194435.2177246831746410691.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 03:51:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Finish converting all the old inode_cluster_size >> inopblog users to
> inodes_per_cluster.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
