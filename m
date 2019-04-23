Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWG1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 02:27:50 -0400
Date: Mon, 22 Apr 2019 23:27:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: widen quota block counters to 64-bit integers
Message-ID: <20190423062750.GF28518@infradead.org>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
 <155546518873.176148.11756573764233413857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546518873.176148.11756573764233413857.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and yes, I wouldn't mind the cast removal either).
