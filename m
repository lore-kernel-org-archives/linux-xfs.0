Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51616 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754175AbeFTDfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 23:35:48 -0400
Subject: Re: [GIT PULL] xfsprogs: SPDX tag conversion
References: <20180620032343.GM19934@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <baf927da-1b22-f441-511e-1eefee9c61a2@sandeen.net>
Date: Tue, 19 Jun 2018 22:35:47 -0500
MIME-Version: 1.0
In-Reply-To: <20180620032343.GM19934@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: esandeen@redhat.com

On 6/19/18 10:23 PM, Dave Chinner wrote:
> Hi Eric,
> 
> Can you please pull the branch below with the xfsprogs repository
> SPDX tag conversion in it? It is based on te libxfs-4.18-sync branch
> of the upstream repo. The change is too big for the mailing list,
> and is mostly scripted. The process and scripts are in the commit
> message, and matches what I've done for the kernel code and
> xfstests.

Thanks Dave.  To not have too many balls in the air I hope to get
xfsprogs-4.17 out before I really get going on 4.18 but I'll tee
this up early.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 
> The following changes since commit e05de95096511e8d63dd0648435d88265a2231c3:
> 
>   xfs: fix error handling in xfs_refcount_insert() (2018-06-07 14:54:17 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev spdx-tags
> 
> for you to fetch changes up to 2d86556ec32e49442557acf87d4beb11b603cb76:
> 
>   xfsprogs: convert to SPDX license tags (2018-06-20 13:17:45 +1000)
> 
> ----------------------------------------------------------------
> Dave Chinner (1):
>       xfsprogs: convert to SPDX license tags
