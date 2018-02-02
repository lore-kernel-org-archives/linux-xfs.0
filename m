Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35425 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754053AbeBBSIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 13:08:38 -0500
Date: Fri, 2 Feb 2018 10:08:37 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't allow DAX on reflink filesystems
Message-ID: <20180202180837.GA11834@infradead.org>
References: <20180131222324.GH4849@magnolia>
 <20180202095131.GB17952@infradead.org>
 <20180202174733.GA4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180202174733.GA4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Fri, Feb 02, 2018 at 09:47:33AM -0800, Darrick J. Wong wrote:
> I haven't received any such patch (but Oracle mail has been dropping and
> delaying mail recently) and marc.info doesn't bring up anything relevant
> for a search of 'DAX' and 'Hellwig'. :/

I've found my local commits from Jan 18, but it seems like they never
made it out, despite me remembering sending them.  So it looks the issue
was in my side.
