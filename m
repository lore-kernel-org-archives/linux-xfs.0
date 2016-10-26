Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50046 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754631AbcJZBNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 21:13:53 -0400
Date: Tue, 25 Oct 2016 18:13:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/39] xfs_db: print one array element per line
Message-ID: <20161026011343.GD23568@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743669846.11035.8419161903309169766.stgit@birch.djwong.org>
 <20161026005138.GE23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026005138.GE23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 11:51:38AM +1100, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 04:04:58PM -0700, Darrick J. Wong wrote:
> > Print one array element per line so that the debugger output isn't
> > a gigantic pile of screen snow.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> What commands does this affect?

The 'print' command.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
