Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23751 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751501AbdJPBiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 21:38:00 -0400
Date: Mon, 16 Oct 2017 12:31:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/30] xfs: scrub btree keys and records
Message-ID: <20171016013159.GP3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777252271.1724.14750284606958135759.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777252271.1724.14750284606958135759.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add to the btree scrubber the ability to check that the keys and
> records are in the right order and actually call out to our record
> iterator to do actual checking of the records.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
