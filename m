Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965840AbcKOKZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:25:45 -0500
Date: Tue, 15 Nov 2016 02:25:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/10] xfs: check minimum block size for CRC filesystems
Message-ID: <20161115102544.GZ1607@infradead.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
 <147830465785.27129.17151401159795461152.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830465785.27129.17151401159795461152.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:10:57PM -0700, Darrick J. Wong wrote:
> Check the minimum block size on v5 filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Same comment on unlikely as for the xfsprogs version, otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
