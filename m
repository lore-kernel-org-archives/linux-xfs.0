Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:49985 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbeKCIqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 04:46:07 -0400
Date: Sat, 3 Nov 2018 10:36:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] vfs: fix many problems in vfs clone/dedupe
 implementation
Message-ID: <20181102233651.GH19305@dastard>
References: <20181102051459.GS6311@dastard>
 <CAHk-=whrpyMSWM4wxYE+E4fSbpkD3yBATjLnzvvAKBfhGwUaAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whrpyMSWM4wxYE+E4fSbpkD3yBATjLnzvvAKBfhGwUaAw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: djwong@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Fri, Nov 02, 2018 at 09:35:23AM -0700, Linus Torvalds wrote:
> On Thu, Nov 1, 2018 at 10:15 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > Can you please pull update containing a rework of the VFS clone and
> > dedupe file range infrastructure from the tag listed below?
> 
> I don't love the timing of this at the end of the merge window, but pulled,

When would have been a better time? It's too big for a late -rc, and
it contains stuff that needs fixing pretty urgently. So if the merge
window is not appropriate, what should we have done here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
