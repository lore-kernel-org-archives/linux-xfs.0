Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbeKTSlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 13:41:09 -0500
Date: Tue, 20 Nov 2018 00:13:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfs: fix transient reference count error in
 xfs_buf_resubmit_failed_buffers
Message-ID: <20181120081319.GC30481@infradead.org>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119210459.8506-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
