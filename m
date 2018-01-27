Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38705 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbeA0Hb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 02:31:58 -0500
Date: Fri, 26 Jan 2018 23:31:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: reflink should break pnfs leases before sharing
 blocks
Message-ID: <20180127073155.GA11515@infradead.org>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
 <151701541571.3070.9498021803548418301.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151701541571.3070.9498021803548418301.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, bfoster@redhat.com, linux-xfs@vger.kernel.org

Still not a big fan of the code flow, but I guess we need the fix for
now and can clean up later..

Reviewed-by: Christoph Hellwig <hch@lst.de>
