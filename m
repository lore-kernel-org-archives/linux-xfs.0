Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34015 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941354AbcKOKZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:25:21 -0500
Date: Tue, 15 Nov 2016 02:25:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: check return value of
 _trans_reserve_quota_nblks
Message-ID: <20161115102520.GY1607@infradead.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
 <147830465179.27129.2945083749679541980.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830465179.27129.2945083749679541980.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:10:51PM -0700, Darrick J. Wong wrote:
> Check the return value of xfs_trans_reserve_quota_nblks for errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
