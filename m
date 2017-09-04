Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52290 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753953AbdIDTaC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 15:30:02 -0400
Date: Mon, 4 Sep 2017 12:30:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: evict CoW fork extents when performing
 finsert/fcollapse
Message-ID: <20170904193001.GA12275@infradead.org>
References: <20170904154941.GB4660@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904154941.GB4660@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>

Looks fine (at least for now):

Reviewed-by: Christoph Hellwig <hch@lst.de>
