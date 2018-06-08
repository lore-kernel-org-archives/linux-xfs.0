Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbeFHGXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 02:23:23 -0400
Date: Thu, 7 Jun 2018 23:23:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: clean up MIN/MAX
Message-ID: <20180608062322.GA22309@infradead.org>
References: <20180607052751.6541-1-david@fromorbit.com>
 <20180607052751.6541-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607052751.6541-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 03:27:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Get rid of the MIN/MAX macros and just use the native min/max macros
> directly in the XFS code.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
