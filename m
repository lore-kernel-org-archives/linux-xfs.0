Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57169 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbcJZKe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:34:28 -0400
Date: Wed, 26 Oct 2016 03:34:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/39] xfs_io: try to unshare copy-on-write blocks via
 fallocate
Message-ID: <20161026103427.GO29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743674989.11035.3299885515631848323.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743674989.11035.3299885515631848323.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:05:49PM -0700, Darrick J. Wong wrote:
> Wire up the "unshare" flag to the xfs_io fallocate command.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
