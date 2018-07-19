Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbeGSRYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 13:24:54 -0400
Date: Thu, 19 Jul 2018 09:40:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/8] xfs: check leaf attribute block freemap in
 verifier
Message-ID: <20180719164055.GD10151@infradead.org>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192903434.31685.282625226695514597.stgit@magnolia>
 <20180719152516.GG4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719152516.GG4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>

On Thu, Jul 19, 2018 at 08:25:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the leaf attribute freemap when we're verifying the block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
