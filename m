Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24810 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWS4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 13:56:19 -0500
Date: Mon, 23 Jan 2017 10:56:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: fix COW writeback race
Message-ID: <20170123185613.GD4780@birch.djwong.org>
References: <1484837472-14368-1-git-send-email-hch@lst.de>
 <20170120162507.GC12985@birch.djwong.org>
 <20170123121808.GA27889@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170123121808.GA27889@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 01:18:08PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 20, 2017 at 08:25:07AM -0800, Darrick J. Wong wrote:
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Applied, thanks.
> 
> I haven't seen it in any tree yet.  I'd love to see it in -rc6
> and include it in my next -stable backport.

Yeah, it'll be in the rc fixes branch tonight.

--D
