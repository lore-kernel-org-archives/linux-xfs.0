Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59239 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755600AbcKOKUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:20:01 -0500
Date: Tue, 15 Nov 2016 02:20:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/16] libxfs: fix line lengths
Message-ID: <20161115102000.GL1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830455401.26713.11368437004356317380.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830455401.26713.11368437004356317380.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Fri, Nov 04, 2016 at 05:09:14PM -0700, Darrick J. Wong wrote:
> Fix some 80-char line length issues.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> ---

Is this a port from the kernel tree?  Otherwise looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>
