Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51371 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbcJCSBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 14:01:34 -0400
Date: Mon, 3 Oct 2016 11:01:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflink trees updated for 4.9
Message-ID: <20161003180132.GA6469@infradead.org>
References: <20161002190106.GC21076@birch.djwong.org>
 <20161003172123.GD21076@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161003172123.GD21076@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, amir73il@gmail.com

On Mon, Oct 03, 2016 at 10:21:23AM -0700, Darrick J. Wong wrote:
> On Sun, Oct 02, 2016 at 12:01:07PM -0700, Darrick J. Wong wrote:
> > Seeing as 4.8 is probably going out today, here's the latest for-4.9 branch:
> > 
> > https://github.com/djwong/linux/tree/for-dave-for-4.9-9
> > https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-9
> > https://github.com/djwong/xfstests/tree/djwong-devel
> 
> Rebased against yesterday's for-next:

Just when I finished testing the previous iteration, which went all
fine, btw.
