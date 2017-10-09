Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38255 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754225AbdJISrl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 14:47:41 -0400
Date: Mon, 9 Oct 2017 11:47:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/4] xfs: miscellaneous fixes
Message-ID: <20171009184736.GS7122@magnolia>
References: <20171008235414.13866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171008235414.13866-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 10:54:10AM +1100, Dave Chinner wrote:
> Darrick,
> 
> These are fixes that have been sitting in my test tree for a while,
> so I thought I better get them cleaned out and up into the main
> tree. They all address recent reported problems on the list - the RT
> is not directly related to a user bug report but is something I
> did while looking at the recent CVE issue.
> 
> Please consider for merge.

For patches 1-3,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Will run them through a test cycle and see what happens.

(Still trying to wrap my head around #4 having screwed up in that area
once already.)

--D

> 
> -Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
