Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34171 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdIAUGX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 16:06:23 -0400
Date: Fri, 1 Sep 2017 22:06:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/8] xfs: use xfs_iext_get_extent in
        xfs_bmap_first_unused
Message-ID: <20170901200621.GA24728@lst.de>
References: <20170829174835.2218-1-hch@lst.de> <20170829174835.2218-4-hch@lst.de> <20170829184148.GX4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829184148.GX4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 11:41:48AM -0700, Darrick J. Wong wrote:
> This probably ought to have a justification in the changelog, such as
> "Use the bmap abstraction instead of open-coding bmbt details here."
> 
> Code otherwise looks ok.

Sure.  Do you just want to add the above?
