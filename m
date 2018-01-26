Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47719 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbeAZJHz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 04:07:55 -0500
Date: Fri, 26 Jan 2018 01:07:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] xfs: call xfs_qm_dqattach before performing
 reflink operations
Message-ID: <20180126090755.GB29115@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676029707.12349.10129452204983633139.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676029707.12349.10129452204983633139.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
