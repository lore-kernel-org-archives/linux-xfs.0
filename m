Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:36144 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753600AbdHUXCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 19:02:37 -0400
Date: Tue, 22 Aug 2017 09:02:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Support for data CRC
Message-ID: <20170821230232.GS10621@dastard>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821190414.long2535xppcxvvd@breakpoint.cc>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 21, 2017 at 09:04:15PM +0200, Sebastian Andrzej Siewior wrote:
> Hi,
> 
> my understanding is that only metadata is protected by CRC in the new
> on-disk format. Are there any plans to also protect data?

Not in XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
