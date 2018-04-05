Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:58083 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbeDEXQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 19:16:00 -0400
Date: Fri, 6 Apr 2018 09:15:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/21] xfs: create tracepoints for online repair
Message-ID: <20180405231558.GM23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269902560.16346.8884310220405291359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269902560.16346.8884310220405291359.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:57:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> These tracepoints will be used to debug the online repair routines.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok. I can't really comment on their contents until I have to
use them to debug a problem...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
