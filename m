Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51534 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751337AbdAWWGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 17:06:47 -0500
Date: Tue, 24 Jan 2017 09:06:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quota-enabled XFS hangs during mount
Message-ID: <20170123220643.GA316@dastard>
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
 <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
 <20161103013153.GH9920@dastard>
 <7993e9b8-6eb8-6a0d-aa72-01346cca1b63@zoner.cz>
 <20161103204049.GA28177@dastard>
 <43ca55d0-6762-d54f-5ba9-a83f9c1988f6@zoner.cz>
 <20170123134452.GA33287@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170123134452.GA33287@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Martin Svec <martin.svec@zoner.cz>, linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 08:44:52AM -0500, Brian Foster wrote:
> On Mon, Jan 23, 2017 at 10:44:20AM +0100, Martin Svec wrote:
> > Hello Dave,
> > 
> > Any updates on this? It's a bit annoying to workaround the bug by increasing RAM just because of the
> > initial quotacheck.
> > 
> 
> Note that Dave is away on a bit of an extended vacation[1]. It looks
> like he was in the process of fishing through the code to spot any
> potential problems related to quotacheck+reclaim. I see you've cc'd him
> directly so we'll see if we get a response wrt to if he got anywhere
> with that...

No, I didn't.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
