Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51180 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964933AbeEIPP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 11:15:57 -0400
Date: Wed, 9 May 2018 08:15:56 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 02/33] fs: factor out a __generic_write_end helper
Message-ID: <20180509151556.GB1313@bombadil.infradead.org>
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509074830.16196-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 09:47:59AM +0200, Christoph Hellwig wrote:
>  }
>  EXPORT_SYMBOL(generic_write_end);
>  
> +
>  /*

Spurious?

