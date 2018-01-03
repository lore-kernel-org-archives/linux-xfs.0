Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59345 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750927AbeACAtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:49:43 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eWXFS-00075y-6F; Wed, 03 Jan 2018 11:49:38 +1100
Date: Wed, 3 Jan 2018 11:49:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/20] xfs: dump the first 128 bytes of any corrupt buffer
Message-ID: <20180103004938.GI5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399134865.23543.2687306518339510402.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399134865.23543.2687306518339510402.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:09:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Increase the corrupt buffer dump to the first 128 bytes since v5
> filesystems have larger block headers than before.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
