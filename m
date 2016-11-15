Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54697 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966031AbcKOKPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:15:46 -0500
Date: Tue, 15 Nov 2016 02:15:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/16] xfs_io: fix libxfs naming violation
Message-ID: <20161115101545.GC1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830449771.26713.16395684581974689675.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830449771.26713.16395684581974689675.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:08:17PM -0700, Darrick J. Wong wrote:
> All the calls to libxfs code should start with 'libxfs'
> per libxfs_api_defs.h.

Looks fine (although I'm not a big fan of the big rename in general):

Reviewed-by: Christoph Hellwig <hch@lst.de>
