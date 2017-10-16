Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23883 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751498AbdJPBia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 21:38:30 -0400
Date: Mon, 16 Oct 2017 12:32:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/30] xfs: create helpers to scan an allocation group
Message-ID: <20171016013253.GQ3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777252881.1724.797907625131044293.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777252881.1724.797907625131044293.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some helpers to enable us to lock an AG's headers, create btree
> cursors for all btrees in that allocation group, and clean up
> afterwards.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
