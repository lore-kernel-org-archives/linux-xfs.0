Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751931AbdAIPnt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 10:43:49 -0500
Date: Mon, 9 Jan 2017 10:43:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: minleft fixes V2
Message-ID: <20170109154347.GC22368@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <20170105012159.GS1859@eguan.usersys.redhat.com>
 <20170105020105.GC17846@birch.djwong.org>
 <20170108103647.GD26451@lst.de>
 <20170108160959.GD62847@bfoster.bfoster>
 <20170108181002.GA3732@birch.djwong.org>
 <20170109152205.GA22368@bfoster.bfoster>
 <20170109153415.GA27197@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109153415.GA27197@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 04:34:15PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 09, 2017 at 10:22:06AM -0500, Brian Foster wrote:
> > Hmm, is this something that can be enabled locally (e.g., on posts to
> > the list) without having to merge stuff prematurely?
> 
> Any linux developer can add their repos to the kbuild bot.  I usually
> push my non-trivial patchset to one of my repos covered by it before
> sending them out.

Interesting, thanks. Though I guess that depends on having a publicly
accessible repo.. I suppose we could also define a for-kbuild or
for-testing branch or some such, but that's up to Darrick...

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
