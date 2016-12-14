Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755322AbcLNKpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2016 05:45:11 -0500
Date: Wed, 14 Dec 2016 02:45:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: nuke unused tracepoint definitions
Message-ID: <20161214104503.GC16862@infradead.org>
References: <ab512340-9567-cc58-e0a8-7891041d1d12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab512340-9567-cc58-e0a8-7891041d1d12@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 07, 2016 at 02:05:50PM -0600, Eric Sandeen wrote:
> This is all unused code, so remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
