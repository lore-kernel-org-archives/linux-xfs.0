Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60431 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966686AbcKOKVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:21:48 -0500
Date: Tue, 15 Nov 2016 02:21:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/16] xfs: check return value of
 _trans_reserve_quota_nblks
Message-ID: <20161115102147.GO1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830457222.26713.9534352090140316164.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830457222.26713.9534352090140316164.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:09:32PM -0700, Darrick J. Wong wrote:
> Check the return value of xfs_trans_reserve_quota_nblks for errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
