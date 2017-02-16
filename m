Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43769 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPU2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 15:28:30 -0500
Date: Thu, 16 Feb 2017 12:28:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Use xfs_icluster_size_fsb() to calculate inode
 chunk alignment
Message-ID: <20170216202829.GG18385@infradead.org>
References: <1487249852-27104-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487249852-27104-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, sandeen@sandeen.net

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
