Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43321 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751674AbcLNThb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 14:37:31 -0500
Date: Wed, 14 Dec 2016 20:37:29 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] xfs: adjust allocation length in
        xfs_alloc_space_available
Message-ID: <20161214193729.GA12217@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-4-git-send-email-hch@lst.de> <20161214182432.GC24645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214182432.GC24645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Dec 14, 2016 at 01:24:32PM -0500, Brian Foster wrote:
> Nit: could we assert args->maxlen >= args->minlen here as well?

Sure..
