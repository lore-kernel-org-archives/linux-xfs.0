Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:6591 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750914AbcJJF13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 01:27:29 -0400
Date: Mon, 10 Oct 2016 16:27:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: fix label inaccuracies
Message-ID: <20161010052706.GS9806@dastard>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588167051.12127.12421314963194053634.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588167051.12127.12421314963194053634.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:07:50PM -0700, Darrick J. Wong wrote:
> Since we don't unlock anything on the way out, change the label.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Brian Foster <bfoster@redhat.com>


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
