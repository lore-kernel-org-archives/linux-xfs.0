Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20296 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933191AbdKAVN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:13:59 -0400
Date: Thu, 2 Nov 2017 08:11:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: scrub extended attribute leaf space
Message-ID: <20171101211122.GQ5858@dastard>
References: <20171031225532.GD4911@magnolia>
 <20171101062251.GI4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101062251.GI4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 31, 2017 at 11:22:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> As we walk the attribute btree, explicitly check the structure of the
> attribute leaves to make sure the pointers make sense and the freemap is
> sensible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok.


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
