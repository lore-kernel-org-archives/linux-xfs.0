Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:25152 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752295AbcLHW7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 17:59:06 -0500
Date: Fri, 9 Dec 2016 09:58:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to a444d72e6090
Message-ID: <20161208225849.GL4219@dastard>
References: <20161207202501.GK4326@dastard>
 <20161208063600.GY16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161208063600.GY16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 10:36:00PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 08, 2016 at 07:25:01AM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > The for-next branch of the xfs kernel repository at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> > 
> > has just been updated. This update contains a bunch of verification
> > enhancments to detect field corruptions as metadata is read from
> > disk, faster CRC calculations, a faster buffer cache indexing
> > structure and some cleanups.
> > 
> > With the merge window likely to open next week, this may be the last
> > update for the 4.10-rc1 cycle.  Let me know if there's anything
> > critical that I've missed for 4.10 so I can sort it out before the
> > end of the week.
> 
> Well I /was/ sorta hoping that you'd have time to review the online
> scrub patches for 4.10, but unless you're already digging through them I
> probably ought to just put out a call for online scrub reviewers for 4.11.

I started on them, but I just haven't been able to spend any
substantial time reading them or testing them so, unfortunately,
it's going to have to miss 4.10 at this point.

> You're not missing anything critical from my trees, however.

Thanks for checking!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
