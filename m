Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 02:53:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m939rrhg028053
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 02:53:53 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF3261370DB7
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 02:55:31 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id XFiWDyNTURoNTihg for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 02:55:31 -0700 (PDT)
Date: Fri, 3 Oct 2008 19:55:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 957103 - Merge up to 2.6.27-rc8
Message-ID: <20081003095527.GN30001@disturbed>
References: <20081003031258.7886658C52B4@chook.melbourne.sgi.com> <20081003091001.GA11627@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003091001.GA11627@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

On Fri, Oct 03, 2008 at 05:10:01AM -0400, Christoph Hellwig wrote:
> So this patch now has made it out to the CVS on oss, but not the actual
> update of the surrouding kernel tree.  Any chance to fix that before the
> weekend so we'll actually have a tree the builds?

I just noticed the master branch on the git tree on oss has been
updated - it's got all the btree patches in it. It seems to build
just fine - I haven't run it through xfsqa yet - still updating
patches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
