Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdIMQS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 12:18:28 -0400
Date: Wed, 13 Sep 2017 09:18:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: backport request/question
Message-ID: <20170913161827.GA12667@infradead.org>
References: <CAGbvivJv=qSRA6Vm2ggjpYcg59gXA0YroYcUHmsJXUfqodtzjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGbvivJv=qSRA6Vm2ggjpYcg59gXA0YroYcUHmsJXUfqodtzjQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 13, 2017 at 10:48:40AM -0400, Wyllys Ingersoll wrote:
> Are the recent XFS fixes in the 4.13 kernel planned for backport to
> 4.12 or 4.9 kernels?

I plan to maintain the 4.9-stable backports, and will do another
big round in the next days.

I don't plan to update 4.12, and I don't even think that stable tree
is even active anymore.
