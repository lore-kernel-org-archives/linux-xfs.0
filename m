Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbcI3Hyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:54:51 -0400
Date: Fri, 30 Sep 2016 00:54:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 46/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20160930075450.GG17618@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
