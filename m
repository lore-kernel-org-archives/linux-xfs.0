Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36657 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751573AbdBFUz5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 15:55:57 -0500
Date: Mon, 6 Feb 2017 21:55:50 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: reflink direct I/O improvements V3
Message-ID: <20170206205550.GA3337@lst.de>
References: <20170206074738.13978-1-hch@lst.de> <20170206184139.GF3580@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206184139.GF3580@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 10:41:39AM -0800, Darrick J. Wong wrote:
> I think "xfs: reject all unaligned direct writes to reflinked files" is
> missing from this patchset?  If so, you can send it as a reply to the
> cover letter email.

I sent it out separately as I have no idea how to use git-send-email
to reply to an existing thread.
