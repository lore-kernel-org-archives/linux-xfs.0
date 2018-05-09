Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbeEIGNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 02:13:47 -0400
Date: Tue, 8 May 2018 23:13:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] xfs: don't assert fail with AIL lock held
Message-ID: <20180509061346.GA25104@infradead.org>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508034202.10136-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Not really excited about this, but if it helps you debugging the AIL
code:

Reviewed-by: Christoph Hellwig <hch@lst.de>
