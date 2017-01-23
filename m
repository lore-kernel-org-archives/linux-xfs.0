Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41114 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdAWMSZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 07:18:25 -0500
Date: Mon, 23 Jan 2017 13:18:08 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: fix COW writeback race
Message-ID: <20170123121808.GA27889@lst.de>
References: <1484837472-14368-1-git-send-email-hch@lst.de> <20170120162507.GC12985@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170120162507.GC12985@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Jan 20, 2017 at 08:25:07AM -0800, Darrick J. Wong wrote:
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Applied, thanks.

I haven't seen it in any tree yet.  I'd love to see it in -rc6
and include it in my next -stable backport.
