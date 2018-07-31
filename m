Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37924 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbeGaQuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 12:50:13 -0400
Date: Tue, 31 Jul 2018 08:09:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: move extent busy tree initialization to
 xfs_initialize_perag
Message-ID: <20180731150928.GA13875@infradead.org>
References: <20180731035812.GU30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731035812.GU30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

I don't really understand why you want this, but it does look correct
to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
