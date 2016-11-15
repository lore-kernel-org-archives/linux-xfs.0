Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966567AbcKOKXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:23:33 -0500
Date: Tue, 15 Nov 2016 02:23:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/10] libxfs: fix xfs_attr_shortform_bytesfit declaration
Message-ID: <20161115102332.GT1607@infradead.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
 <147830462123.27129.14215241376782136478.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830462123.27129.14215241376782136478.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Fri, Nov 04, 2016 at 05:10:21PM -0700, Darrick J. Wong wrote:
> Change the xfs_attr_shortform_bytesfit declaration to have
> struct xfs_inode to avoid tripping up the libxfs-diff scanner.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
