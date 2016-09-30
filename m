Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbcI3ITj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:19:39 -0400
Date: Fri, 30 Sep 2016 01:19:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 49/63] xfs: don't allow reflink when the AG is low on
 space
Message-ID: <20160930081917.GB32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520505883.29434.18153308905938659361.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520505883.29434.18153308905938659361.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
