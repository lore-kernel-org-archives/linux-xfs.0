Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50894 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3IXc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:23:32 -0400
Date: Fri, 30 Sep 2016 01:23:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 52/63] xfs: increase log reservations for reflink
Message-ID: <20160930082331.GE32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520507840.29434.13617252095470528080.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520507840.29434.13617252095470528080.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:11:18PM -0700, Darrick J. Wong wrote:
> Increase the log reservations to handle the increased rolling that
> happens at the end of copy-on-write operations.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
