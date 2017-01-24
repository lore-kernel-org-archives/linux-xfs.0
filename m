Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdAXRJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 12:09:35 -0500
Date: Tue, 24 Jan 2017 09:09:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/122: reduce xfs_dsb_t size
Message-ID: <20170124170930.GA24572@infradead.org>
References: <20170124170819.GP14033@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124170819.GP14033@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jan 24, 2017 at 09:08:19AM -0800, Darrick J. Wong wrote:
> We're not going to do reverse-mapping on the realtime device for
> some time, so let's fix xfs/122 in the meantime.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
