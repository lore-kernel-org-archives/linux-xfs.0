Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34131 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932311AbcJZKjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:39:45 -0400
Date: Wed, 26 Oct 2016 03:39:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/39] man: document the inode cowextsize flags & fields
Message-ID: <20161026103944.GS29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743677455.11035.16363741138480682509.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743677455.11035.16363741138480682509.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:06:14PM -0700, Darrick J. Wong wrote:
> Document the new copy-on-write extent size fields and inode flags
> available in struct fsxattr.

Looks fine.  Btw, now that fsxattr is in common code should this
documentation move to or be duplicated in the man-pages project?

Reviewed-by: Christoph Hellwig <hch@lst.de>
