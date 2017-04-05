Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933279AbdDELRU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 07:17:20 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170405111048.GB22845@eguan.usersys.redhat.com>
References: <20170405111048.GB22845@eguan.usersys.redhat.com> <20170405104205.GZ22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk> <2718.1491389955@warthog.procyon.org.uk>
Subject: Re: Should xfstest generic/388 be using _require_command for fsstress?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3377.1491391037.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 12:17:17 +0100
Message-ID: <3378.1491391037@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, bfoster@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> > Also, should 388 be printing "Silence is golden" at the end of the test?
> 
> Yes, and it does print this message, but in the middle of test, not end.

Yes.  I know it prints the message but not at the end.  Why the middle and not
the end is the question?

David
