Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imslp-west.kjsl.com ([65.50.211.133]:39248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753470AbdASQNu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2017 11:13:50 -0500
Date: Thu, 19 Jan 2017 06:58:43 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: add DAX and CoW extent-size flags to chattr
 manpage
Message-ID: <20170119145843.GA19296@infradead.org>
References: <20170119073511.11590-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119073511.11590-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2017 at 03:35:11PM +0800, Eryu Guan wrote:
> Manpage is not updated after adding set/clear DAX and CoW
> extent-size flags support to xfs_io.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
