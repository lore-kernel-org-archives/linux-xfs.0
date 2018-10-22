Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53428 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbeJWCCp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Oct 2018 22:02:45 -0400
Date: Mon, 22 Oct 2018 10:43:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsdump cleaning patchset
Message-ID: <20181022174316.GA28561@infradead.org>
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Mon, Oct 22, 2018 at 07:26:17PM +0200, Jan Tulak wrote:
> Hi guys
> 
> I did some xfsdump cleaning where I focused on getting rid of all the
> memory leaks reported by Coverity. There is still a lot of things to
> do for another time: issues by Coverity that were not fixed in this
> set, sprintf -> snprintf because there is a plenty of places for
> buffer overflow, etc...
> 
> The set has about 30 patches, so I won't spam the mailing list with
> the first iteration of review and instead, I uploaded it here:
> https://github.com/jtulak/xfsdump/tree/for-review

Please send an actual patch series, github is completely unusable
for reviews..
