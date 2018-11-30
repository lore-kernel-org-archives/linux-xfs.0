Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:15492
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbeK3SyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 13:54:14 -0500
Date: Fri, 30 Nov 2018 18:45:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181130074547.GY6311@dastard>
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
 <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130064908.GX6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Babrou <ivan@cloudflare.com>
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Fri, Nov 30, 2018 at 05:49:08PM +1100, Dave Chinner wrote:
> Seriously: describe your workload in detail for me so I can write a
> reproducer for it. Without that I cannot help you any further and I
> am just wasting my time asking you to describe the workload over
> and over again.

FWIW, here's the discussion that about the FB issue. Go read it,
the first few emails are pretty much the same as this thread so far.

https://www.spinics.net/lists/linux-xfs/msg01541.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
