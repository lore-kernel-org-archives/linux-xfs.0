Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50948 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbdATKD7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 05:03:59 -0500
Date: Fri, 20 Jan 2017 02:03:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] xfs: fix eofblocks race with file extending async
 dio writes
Message-ID: <20170120100358.GC32659@infradead.org>
References: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
 <1484852411-1137-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484852411-1137-4-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
