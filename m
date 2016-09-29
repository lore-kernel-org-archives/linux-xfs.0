Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932897AbcI2QsL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 12:48:11 -0400
Date: Thu, 29 Sep 2016 09:48:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/63] vfs: support FS_XFLAG_COWEXTSIZE and get/set of
 CoW extent size hint
Message-ID: <20160929164810.GA4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503121698.30303.9684501453641572309.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503121698.30303.9684501453641572309.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Sep 27, 2016 at 07:53:37PM -0700, Darrick J. Wong wrote:
> Introduce XFLAGs for the new XFS CoW extent size hint, and actually
> plumb the CoW extent size hint into the fsxattr structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
