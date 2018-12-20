Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54439 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387679AbeLTRlb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 12:41:31 -0500
Date: Thu, 20 Dec 2018 18:41:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in
 iomap_page_create/release()"
Message-ID: <20181220174130.GA21065@lst.de>
References: <20181220122324.17082-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220122324.17082-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pjaroszynski@nvidia.com, william.kucharski@oracle.com, stable@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, torvalds@linux-foundation.org

Lets fix the problem instead.  I'll dig into it.
