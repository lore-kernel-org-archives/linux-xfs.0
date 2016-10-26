Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752779AbcJZKty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:49:54 -0400
Date: Wed, 26 Oct 2016 03:49:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 27/39] xfs_repair: check the existing refcount btree
Message-ID: <20161026104953.GB8254@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743678891.11035.6488664698227918852.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743678891.11035.6488664698227918852.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:06:28PM -0700, Darrick J. Wong wrote:
> Spot-check the refcount btree for obvious errors, and mark the
> refcount btree blocks as such.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
