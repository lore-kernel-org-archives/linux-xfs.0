Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeDEHLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 03:11:19 -0400
Date: Thu, 5 Apr 2018 00:11:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: remove unused flags arg from xfs_dquot_verify
Message-ID: <20180405071119.GA17256@infradead.org>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <51e940bc-9bcd-0fe6-ac90-003eae7e24f0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51e940bc-9bcd-0fe6-ac90-003eae7e24f0@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 01:49:09PM -0500, Eric Sandeen wrote:
> Long ago the flags argument was used to determine whether
> to issue warnings about corruptions, but that's done elsewhere
> now and the flag is unused here, so remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
