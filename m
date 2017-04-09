Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25576 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752631AbdDITjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Apr 2017 15:39:46 -0400
Date: Sun, 9 Apr 2017 12:39:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #10]
Message-ID: <20170409193905.GS4864@birch.djwong.org>
References: <149146774821.12770.3592235770964461857.stgit@warthog.procyon.org.uk>
 <149146775556.12770.11943651470996193921.stgit@warthog.procyon.org.uk>
 <CAOQ4uxiXF4_N9Zu_OAWzC5STYyNY7VuGRYPeg1m4WPqhyZBOtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXF4_N9Zu_OAWzC5STYyNY7VuGRYPeg1m4WPqhyZBOtA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Apr 09, 2017 at 10:47:10AM +0300, Amir Goldstein wrote:
> On Thu, Apr 6, 2017 at 11:35 AM, David Howells <dhowells@redhat.com> wrote:
> > Add a statx test script that does the following:
> >
> 
> David,
> 
> Just wanted to mention that albeit 'xfs' in 'xfstests', you don't need
> to send generic
> xfstests patched in the future to linux-xfs list.
> I don't know that xfs folks mind, but you're discriminating other-fs folks ;-)

It's a test for generic vfs functionality that has just been wired up in
XFS, so it /is/ appropriate to cc the xfs list.

That said, it just got wired up in ext4 so they should be cc'd as well.

--D

> 
> Cheers,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
