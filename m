Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfGQOxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 10:53:33 -0400
Date: Wed, 17 Jul 2019 07:53:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] iomap: move internal declarations into fs/iomap/
Message-ID: <20190717145317.GC7093@magnolia>
References: <156334313527.360395.511547592522547578.stgit@magnolia>
 <156334318826.360395.9686513875631453909.stgit@magnolia>
 <20190717062231.GB27285@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717062231.GB27285@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

On Tue, Jul 16, 2019 at 11:22:31PM -0700, Christoph Hellwig wrote:
> On Tue, Jul 16, 2019 at 10:59:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move internal function declarations out of fs/internal.h into
> > include/linux/iomap.h so that our transition is complete.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Didn't I ack this earlier?
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

<urk> Yep, sorry, it was late.  Fixed. :/

--D
