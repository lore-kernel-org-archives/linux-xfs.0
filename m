Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdLUNhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 08:37:45 -0500
Date: Thu, 21 Dec 2017 05:37:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: don't be so eager to clear the cowblocks tag on
 truncate
Message-ID: <20171221133744.GB10079@infradead.org>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335788573.26575.10453091656387965703.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151335788573.26575.10453091656387965703.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
