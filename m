Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbcJZKeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:34:06 -0400
Date: Wed, 26 Oct 2016 03:34:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/39] xfs_io: provide long-format help for falloc
Message-ID: <20161026103405.GN29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743674377.11035.8133878879225366578.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743674377.11035.8133878879225366578.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:05:43PM -0700, Darrick J. Wong wrote:
> Provide long-format help for falloc so that xfstests can use
> _require_xfs_io_command to check for falloc command line args.

As it turns out checking those args isn't actually suitable.

But documentation is always good to have, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
