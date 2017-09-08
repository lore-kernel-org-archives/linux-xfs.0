Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754655AbdIHHcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 03:32:46 -0400
Date: Fri, 8 Sep 2017 00:32:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: check kthread_should_stop() after the setting of
 task state
Message-ID: <20170908073242.GA26110@infradead.org>
References: <1504771497-44154-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504771497-44154-1-git-send-email-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
