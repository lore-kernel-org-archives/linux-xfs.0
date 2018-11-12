Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:60081 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbeKMIDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 03:03:25 -0500
Date: Tue, 13 Nov 2018 09:08:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 200063] XFS corruption: mismatch between format (2) and
 size (0) in symlink
Message-ID: <20181112220816.GO19305@dastard>
References: <bug-200063-201763@https.bugzilla.kernel.org/>
 <bug-200063-201763-KTWUnqKC4W@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-200063-201763-KTWUnqKC4W@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 12, 2018 at 01:31:26PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=200063
> 
> --- Comment #4 from Zorro Lang (zlang@redhat.com) ---
> I still can reproduce this bug on linux v4.20-rc1. So we haven't merged this
> patch (in comment 3), right?

Patch was superceded, and I never got around to posting the new
version. It's still sitting in my stack, I'll try to get it out in
the next coupel of days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
