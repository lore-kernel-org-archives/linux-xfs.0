Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932111AbcJZK3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:29:42 -0400
Date: Wed, 26 Oct 2016 03:29:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/39] xfs_db: metadump should copy the refcount btree too
Message-ID: <20161026102940.GI29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743668609.11035.16781673871765061912.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743668609.11035.16781673871765061912.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Do we have a testcase for metadump on a reflink fs, btw?
