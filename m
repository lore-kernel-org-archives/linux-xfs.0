Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53958 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfFDWEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 18:04:21 -0400
Date: Wed, 5 Jun 2019 08:04:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: refactor inode geometry setup routines
Message-ID: <20190604220417.GZ29573@dread.disaster.area>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968494542.1657505.5981492051798860627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968494542.1657505.5981492051798860627.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Migrate all of the inode geometry setup code from xfs_mount.c into a
> single libxfs function that we can share with xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
