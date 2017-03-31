Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47863 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933127AbdCaQEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 12:04:39 -0400
Date: Fri, 31 Mar 2017 09:04:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 0cbf8c9
Message-ID: <20170331160438.GA3255@infradead.org>
References: <20170330173724.GE4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170330173724.GE4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 30, 2017 at 10:37:24AM -0700, Darrick J. Wong wrote:
> has just been updated.  I intend to try to put in Eric Sandeen's patches
> to perform unlinked inode cleanup during ro mount and my own GETFSMAP
> patches for 4.12, so I put them in along with the other fixes and
> cleanups to get further testing.

Any chance we could not use for-next for stuff that's just queued up
for testing?
