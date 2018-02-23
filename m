Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49445 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750916AbeBWB4o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 20:56:44 -0500
Date: Fri, 23 Feb 2018 01:56:42 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs v4.15.0-rc1 released
Message-ID: <20180223015642.GA27199@wotan.suse.de>
References: <7025bd78-65f9-ad25-e884-cada818a685b@sandeen.net>
 <20180220003635.GA8479@infradead.org>
 <8675595f-abe1-739c-c131-e12737045365@sandeen.net>
 <20180220163347.GB27629@magnolia>
 <20180220210237.GB7000@dastard>
 <b5f653da-d56d-550f-645c-36da93ba7441@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5f653da-d56d-550f-645c-36da93ba7441@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 22, 2018 at 02:49:27PM -0600, Eric Sandeen wrote:
> On 2/20/18 3:02 PM, Dave Chinner wrote:
> > If this is really a huge problem for distros, then wasn't this what
> > someone wanted mkfs config files for?
> 
> Suse folk seem to like that approach, yes.  But while the config
> file facilitates that sort of distro approach, it isn't really
> a hard requirement, I'd think - patching is always an option
> in the end.

Clearly. Its still a nice sensible feature to address any defaults,
and now that I see chinner/mkfs-refactor is merged I'll go work
off of that and post patches again soon.

  Luis
