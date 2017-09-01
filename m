Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47130 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbdIAUIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 16:08:38 -0400
Date: Fri, 1 Sep 2017 13:08:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: use xfs_iext_get_extent in xfs_bmap_first_unused
Message-ID: <20170901200833.GK3775@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-4-hch@lst.de>
 <20170829184148.GX4757@magnolia>
 <20170901200621.GA24728@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901200621.GA24728@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 01, 2017 at 10:06:21PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 29, 2017 at 11:41:48AM -0700, Darrick J. Wong wrote:
> > This probably ought to have a justification in the changelog, such as
> > "Use the bmap abstraction instead of open-coding bmbt details here."
> > 
> > Code otherwise looks ok.
> 
> Sure.  Do you just want to add the above?

Done.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
