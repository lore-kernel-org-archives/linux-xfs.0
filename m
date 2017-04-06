Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755489AbdDFJ3J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 05:29:09 -0400
Date: Thu, 6 Apr 2017 17:28:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by
 chattr [ver #7]
Message-ID: <20170406092856.GJ22845@eguan.usersys.redhat.com>
References: <CAOQ4uxg4s6AsxxYVps1s_KLh-5_FwO40pJ2gPmY9haG8bDjhug@mail.gmail.com>
 <149140993804.27340.4198614944626347024.stgit@warthog.procyon.org.uk>
 <149140996132.27340.12936555593689822963.stgit@warthog.procyon.org.uk>
 <CAOQ4uxgsmKHZ85Qg__zhU13tb4ARLHHWzUoCEvEUE7LNYNnHnQ@mail.gmail.com>
 <11800.1491462484@warthog.procyon.org.uk>
 <15456.1491468961@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15456.1491468961@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 06, 2017 at 09:56:01AM +0100, David Howells wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > The typo is still in v9:
> > 
> > #      $CHATTR_PROG flag       stx_attributes flag
> 
> Aargh.  I missed one.  Shall I post another version with just this change?
> 
> David

No new version needed just for this change. I can fix it at commit time
(if there's no new comments :).

Thanks,
Eryu
