Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42304 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbeLRSFx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 13:05:53 -0500
Date: Tue, 18 Dec 2018 19:05:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181218180551.GA15138@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181206010550.GN24487@magnolia> <20181206200930.GA31797@lst.de> <20181217175922.GI24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217175922.GI24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Dec 17, 2018 at 09:59:22AM -0800, Darrick J. Wong wrote:
> > This and a few other fsx tests assume you can always fallocate
> > on XFS.  I sent a series for this:
> > 
> > https://www.spinics.net/lists/linux-xfs/msg23433.html
> > 
> > But I need to rework some of the patches a little more based on the
> > review feedback.
> 
> "the patches"... as in the fstests patches, or the always_cow series?

The fstests patches.
