Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38065 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFDS6h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 14:58:37 -0400
Date: Tue, 4 Jun 2019 20:58:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: use bios directly in the log code v2
Message-ID: <20190604185810.GA28398@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603173506.GC5390@magnolia> <20190603173816.GA2162@lst.de> <20190604172531.GA1200449@magnolia> <20190604175417.GA27561@lst.de> <20190604184221.GB44563@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604184221.GB44563@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:42:24PM -0400, Brian Foster wrote:
> On Tue, Jun 04, 2019 at 07:54:17PM +0200, Christoph Hellwig wrote:
> > On Tue, Jun 04, 2019 at 10:25:31AM -0700, Darrick J. Wong wrote:
> > > I assume you're going to resubmit the other log item cleanup series at
> > > some point, right? :)
> > 
> > Yes.  I've been waiting for Brian to finish reviewing the remaining
> > patches before resending it.
> 
> I thought I made it through the last post of that series...

Oh, ok.  I'll find some time to respin it then.
