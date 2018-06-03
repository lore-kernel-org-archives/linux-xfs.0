Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63429 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751201AbeFCWe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 18:34:59 -0400
Date: Mon, 4 Jun 2018 08:34:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
Message-ID: <20180603223435.GU10363@dastard>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wen Xu <xuwen.sjtu@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 06:19:54PM -0400, Wen Xu wrote:
> Hi XFS developers and maintainers,
> Please check: https://bugzilla.kernel.org/show_bug.cgi?id=199915

Please report bugs straight to this list - it's much easier to
track and faster to discuss bugs through email than it is through
bugzilla.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
