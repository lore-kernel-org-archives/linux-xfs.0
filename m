Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59814 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751830AbeDRKdY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 06:33:24 -0400
Date: Wed, 18 Apr 2018 12:34:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] blk: add blk_queue_fua() helper function
Message-ID: <20180418103403.GA16044@lst.de>
References: <20180418040828.18165-1-david@fromorbit.com> <20180418040828.18165-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418040828.18165-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

s/blk/block/ for block patches.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
