Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfEOMll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 08:41:41 -0400
Date: Wed, 15 May 2019 05:41:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linus' tree hangs in generic/530
Message-ID: <20190515124140.GA21791@infradead.org>
References: <20190515063208.GA6981@infradead.org>
 <20190515120657.GA2898@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515120657.GA2898@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 08:07:01AM -0400, Brian Foster wrote:
> Have you determined whether this is actually hung btw as opposed to
> hitting some kind of sequence with pathological performance that isn't
> typically hit during the test? I don't recall whether the older kernel
> tests I referred to above resulted in task hung warnings or not, but I
> guess it wouldn't surprise me given how long the tests seemed to take to
> complete (I eventually just killed and expunged them).

I just waited for about an hour and then gave up..
