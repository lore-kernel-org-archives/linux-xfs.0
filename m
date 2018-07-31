Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58522 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbeGaJrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:47:33 -0400
Date: Tue, 31 Jul 2018 01:08:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] misc: remove COPYING from doc/ Makefile
Message-ID: <20180731080825.GA16028@infradead.org>
References: <e4d64c9b-5a1a-54b5-8b69-463738c95307@redhat.com>
 <20180731074313.GA19990@infradead.org>
 <20180731080646.GF2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731080646.GF2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 06:06:46PM +1000, Dave Chinner wrote:
> Sorry, what? I added that as part of my spdx conversion patch. That
> patch also removed the COPYING file.
> 
> How did these changes get merged? I sent a pull request to convert
> everything in xfsprogs and that had all the correct conversions and
> documentation in it. here's the pull request:
> 
> https://marc.info/?l=linux-xfs&m=152948738523911&w=2
> 
> and you can see from the diffstat it did all this stuff...

Ok.  I looked for license info in master but that didn't have the
whole conversion.  That master vs for-next think in the userspace
tools keeps on confusing me..
