Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdAMRcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 12:32:47 -0500
Date: Fri, 13 Jan 2017 09:13:42 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/5] xfs: basic cow fork speculative preallocation
Message-ID: <20170113171342.GC27605@infradead.org>
References: <1484157249-464-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484157249-464-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 12:54:04PM -0500, Brian Foster wrote:
> Hi all,
> 
> Here's v2 of the cow fork speculative prealloc patches. No major changes
> here, as outlined below. Thoughts on any of this?

Any results?  Better performance, less extents for certain workloads?
