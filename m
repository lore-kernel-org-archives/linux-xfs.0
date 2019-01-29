Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12640 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbfA2X2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 18:28:35 -0500
Date: Wed, 30 Jan 2019 10:28:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202441] Possibly vfs cache related replicable xfs
 regression since 4.19.0  on sata hdd:s
Message-ID: <20190129232832.GE4205@dastard>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
 <bug-202441-201763-x9fpm8eS4W@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202441-201763-x9fpm8eS4W@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 11:03:21PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> 
> --- Comment #21 from Roger (rogan6710@gmail.com) ---
> Worked very well :) (compile took 3min 31s) 
> I saw the same behaviour as I first noticed on rc5, sawtoothing buff/cache.

Ok, thanks for confirming. I doubt there's going to be a fast fix
for this, though, but we'll see how it goes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
