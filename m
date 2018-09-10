Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37510 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeIJLjo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Sep 2018 07:39:44 -0400
Date: Sun, 9 Sep 2018 23:47:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20180910064713.GA30888@infradead.org>
References: <20180907015155.32559-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907015155.32559-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, jeffm@suse.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
