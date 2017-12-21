Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdLUNbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 08:31:50 -0500
Date: Thu, 21 Dec 2017 05:31:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: only skip rmap owner checks for unknown-owner
 rmap removal
Message-ID: <20171221133150.GC1567@infradead.org>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
 <151270437900.12194.1274499001703749199.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151270437900.12194.1274499001703749199.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
