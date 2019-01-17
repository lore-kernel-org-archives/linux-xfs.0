Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35903 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfAQHvr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 02:51:47 -0500
Date: Thu, 17 Jan 2019 08:51:45 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: get/put the page in iomap_page_create/release()
Message-ID: <20190117075145.GA29509@lst.de>
References: <20190115211028.15742-1-hch@lst.de> <20190115230744.GM4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115230744.GM4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Piotr Jaroszynski <pjaroszynski@nvidia.com>

On Wed, Jan 16, 2019 at 10:07:45AM +1100, Dave Chinner wrote:
> Missing a SOB.
> 
> But apart from that, I've been running an identical patch in my test
> tree, so:

Piotr: do you still want to claim authorship for this fixed up patch,
in which case I'll need your sob.  Otherwise I can submit it under my
name.
