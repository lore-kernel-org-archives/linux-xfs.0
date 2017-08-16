Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48615 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752384AbdHPVxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 17:53:21 -0400
Date: Wed, 16 Aug 2017 14:52:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing and
 dirtying helpers
Message-ID: <20170816215255.GD4796@magnolia>
References: <20170811151805.22896-1-hch@lst.de>
 <20170811160443.GA24087@magnolia>
 <20170811160658.GA8956@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811160658.GA8956@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, pmenzel@molgen.mpg.de, stockhausen@collogia.de

On Fri, Aug 11, 2017 at 06:06:58PM +0200, Christoph Hellwig wrote:
> On Fri, Aug 11, 2017 at 09:04:43AM -0700, Darrick J. Wong wrote:
> > Looks fine to me,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > (Are you going to push this to Al yourself, or do you want me to drag it
> > through the xfs tree?)
> 
> In general we've maintained iomap.c through the XFS tree so far.
> I think it's easiest to stick to that.

Needs signed-off-by. :(

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
