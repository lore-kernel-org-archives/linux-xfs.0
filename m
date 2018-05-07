Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbeEGOvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 10:51:48 -0400
Date: Mon, 7 May 2018 07:51:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] xfs: fix double ijoin in
 xfs_reflink_cancel_cow_range
Message-ID: <20180507145147.GI7476@infradead.org>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502080157.11386-8-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
