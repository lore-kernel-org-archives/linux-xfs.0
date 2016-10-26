Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33308 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933022AbcJZUtv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 16:49:51 -0400
Date: Wed, 26 Oct 2016 13:49:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20161026204940.GA32036@birch.djwong.org>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1464877150-20457-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> I've had some vocal user requests to allow enabling reflinks at run time,
> which happens to be a mostly trivial feature.  The only caveat is that we
> need a large enough log size to support the reflink requirements, but for
> typical large file systems that's not an issue.

Just out of curiosity, are we still interested in this feature?
A few people were asking on the irc channel today.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
