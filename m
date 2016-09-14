Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40757 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcINUW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 16:22:27 -0400
Date: Wed, 14 Sep 2016 13:22:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] vfs: cap dedupe request structure size at PAGE_SIZE
Message-ID: <20160914202224.GA22621@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216785429.525.1965983896010934181.stgit@birch.djwong.org>
 <20160905145549.GA7662@infradead.org>
 <20160913011620.GC23422@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160913011620.GC23422@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org, david@fromorbit.com, viro@ZenIV.linux.org.uk, linux-xfs@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 06:16:20PM -0700, Darrick J. Wong wrote:
> Ping?  Anyone?

Please resend the patch straight to Linux with a Cc to Al and me.
