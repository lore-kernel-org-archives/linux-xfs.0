Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59657 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdLUNbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 08:31:09 -0500
Date: Thu, 21 Dec 2017 05:31:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: queue deferred rmap ops for cow staging extent
 alloc/free in the right order
Message-ID: <20171221133107.GA1567@infradead.org>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
 <151270436416.12194.13108400111854379733.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151270436416.12194.13108400111854379733.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
