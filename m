Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45246 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeFVGkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:40:14 -0400
Date: Thu, 21 Jun 2018 23:40:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfs: recheck reflink state after grabbing
 ILOCK_SHARED for a write
Message-ID: <20180622064013.GE27254@infradead.org>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960589497.26246.2694743986896972501.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960589497.26246.2694743986896972501.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
