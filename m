Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbeJKNYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:24:45 -0400
Date: Wed, 10 Oct 2018 22:59:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/18] xfsprogs: minor endian annotation fixes
Message-ID: <20181011055902.GC20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-4-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:07PM -0500, Eric Sandeen wrote:
> No actual bugs, just quiet the sparse checker.
> 
> Fixes sparse warnings about this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
