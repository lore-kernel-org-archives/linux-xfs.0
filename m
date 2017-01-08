Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935063AbdAHJwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 04:52:06 -0500
Date: Sun, 8 Jan 2017 01:52:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] duperemove: test presence of dedupe ioctl
Message-ID: <20170108095205.GA4203@infradead.org>
References: <20170106070732.GA14020@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170106070732.GA14020@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@versity.com, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Jan 05, 2017 at 11:07:32PM -0800, Darrick J. Wong wrote:
> Since a zero-length dedupe operation is guaranteed to succeed, use that
> to test whether or not this filesystem supports dedupe.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Didn't you already get my:

Reviewed-by: Christoph Hellwig <hch@lst.de>

earlier?  If not feel free to add it.
