Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQOZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 09:25:26 -0500
Date: Thu, 17 Jan 2019 06:25:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/22] xfs: create library function to reset root inodes
Message-ID: <20190117142525.GG16270@infradead.org>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630929346.18437.14185691799928569579.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630929346.18437.14185691799928569579.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:21:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a library function to reset a root inode, which xfs_repair will
> take advantage of in xfsprogs.

And which will just add dead code to the kernel?
