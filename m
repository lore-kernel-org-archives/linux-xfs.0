Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17018 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751470AbdKICNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:13:38 -0500
Date: Thu, 9 Nov 2017 13:13:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: fix uninitialized return values in scrub code
Message-ID: <20171109021336.GN4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001662619.26786.18307082892827501257.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001662619.26786.18307082892827501257.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 05:03:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix smatch complaints about uninitialized return codes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
