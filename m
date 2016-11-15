Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941497AbcKOKQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:16:51 -0500
Date: Tue, 15 Nov 2016 02:16:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
Message-ID: <20161115101650.GE1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Fri, Nov 04, 2016 at 05:08:30PM -0700, Eric Sandeen wrote:
> >From c400ee3ed1b13d45adde68e12254dc6ab6977b59 Mon Sep 17 00:00:00 2001

It should claim to be from Eric here I think..

And mention that it's a port from a kernel commit.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
