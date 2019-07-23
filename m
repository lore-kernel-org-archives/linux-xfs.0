Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58419 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727821AbfGWWWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 18:22:54 -0400
Date: Wed, 24 Jul 2019 08:21:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Documentation: filesystem: fix "Removed Sysctls" table
Message-ID: <20190723222142.GS7689@dread.disaster.area>
References: <20190723114813.GA14870@localhost>
 <20190723074218.4532737f@lwn.net>
 <20190723145201.GA20658@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723145201.GA20658@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sheriff Esseson <sheriffesseson@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org

On Tue, Jul 23, 2019 at 03:52:01PM +0100, Sheriff Esseson wrote:
> On Tue, Jul 23, 2019 at 07:42:18AM -0600, Jonathan Corbet wrote:
> > On Tue, 23 Jul 2019 12:48:13 +0100
> > Sheriff Esseson <sheriffesseson@gmail.com> wrote:
> > 
> > > the "Removed Sysctls" section is a table - bring it alive with ReST.
> > > 
> > > Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> > 
> > So this appears to be identical to the patch you sent three days ago; is
> > there a reason why you are sending it again now?
> > 
> > Thanks,
> > 
> > jon
> 
> Sorry, I was think the patch went unnoticed during the merge window - I could
> not find a response.

The correct thing to do in that case is to reply to the original
patch and ask if it has been looked at. The usual way of doing this
is quoting the commit message and replying with a "Ping?" comment
to bump it back to the top of everyone's mail stacks.

But, again, 3 days is not a long time, people tend to be extremely
busy and might take a few days to get to reviewing non-critical
changes, and people may not even review patches during the merge
window. I'd suggest waiting a week before pinging a patch you've
sent if there's been no response....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
