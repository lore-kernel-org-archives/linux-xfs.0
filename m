Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbeHEJkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Aug 2018 05:40:52 -0400
Date: Sun, 5 Aug 2018 00:37:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to a0e336ba3e3d
Message-ID: <20180805073714.GA7787@infradead.org>
References: <20180803191730.GX30972@magnolia>
 <20180804090619.GA1888@infradead.org>
 <CAHc6FU4dGZ_XC3ZPt6LJn8BqTZ_VJVK=4Z6vyG41_oGRV1CzVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4dGZ_XC3ZPt6LJn8BqTZ_VJVK=4Z6vyG41_oGRV1CzVA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Sat, Aug 04, 2018 at 04:25:26PM +0200, Andreas Gruenbacher wrote:
> > Did you rebase the tree?  We really need to keep the iomap base
> > branch stable as the gfs2 tree is also based on it and we want to avoid
> > duplicate commits.
> 
> Those hashes look okay to me. We only depend on the iomap-4.19-merge
> branch, and that hasn't changed in a while and is still consistent
> with the gfs2 for-next branch.

Ok, I guess we are fine then.  Listing these as new comments just
looked suspicious.
