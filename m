Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933125AbdDELcL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 07:32:11 -0400
Date: Wed, 5 Apr 2017 19:32:08 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: Should xfstest generic/388 be using _require_command for
 fsstress?
Message-ID: <20170405113208.GD22845@eguan.usersys.redhat.com>
References: <20170405111048.GB22845@eguan.usersys.redhat.com>
 <20170405104205.GZ22845@eguan.usersys.redhat.com>
 <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk>
 <2718.1491389955@warthog.procyon.org.uk>
 <3378.1491391037@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3378.1491391037@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Apr 05, 2017 at 12:17:17PM +0100, David Howells wrote:
> Eryu Guan <eguan@redhat.com> wrote:
> 
> > > Also, should 388 be printing "Silence is golden" at the end of the test?
> > 
> > Yes, and it does print this message, but in the middle of test, not end.
> 
> Yes.  I know it prints the message but not at the end.  Why the middle and not
> the end is the question?

Oh, OK, it doesn't really matter, many tests print it just after setting
test up, as long as it prints it.

Thanks,
Eryu
