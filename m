Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33628 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbeHBLiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 07:38:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id g6-v6so1480273wrp.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 02:47:46 -0700 (PDT)
Date: Thu, 2 Aug 2018 11:47:43 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Clearly state infrastructure change on old XFS website
Message-ID: <20180802094743.iazovxo7xh45fcmn@odin.usersys.redhat.com>
References: <4b3ef7f54f32dc2b61a5d4a33a0e5b2e@wh2.tu-dresden.de>
 <20180730223042.GC4226@magnolia>
 <3f708cdb-4cb0-dd12-0483-ada1025364b9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f708cdb-4cb0-dd12-0483-ada1025364b9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, adam_kalisz <adam_kalisz@wh2.tu-dresden.de>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 30, 2018 at 05:44:35PM -0500, Eric Sandeen wrote:
> 
> 
> On 7/30/18 5:30 PM, Darrick J. Wong wrote:
> > On Sat, Jul 28, 2018 at 11:25:40PM +0200, adam_kalisz wrote:
> >> Dear Darrick,
> >>
> >> I wanted to have a look at the recent new features being added to XFS and
> >> stumbled on the fact, that Google presents me first with the old website [0]
> >> and starting on page 2 of the web results (for the desperate) with the
> >> current website [1].
> >>
> >> It would be most helpful to write some notice to the old website and the
> >> "Getting the latest source code" should point to the current git-repo. It
> >> cost me some time to realize, there is something wrong, because the git log
> >> ended at about 4.9 kernel (~2016) when the infrastructure from sgi probably
> >> got left behind. Also maybe highlight, that the current repo ist xfs-linux
> >> and NOT linux-xfs! It might help some of your possible future colleagues to
> >> get started with XFS.
> > 
> > Sorry about that -- I'll ask those who have write access to xfs.org to
> > update the links.  In the long run I'd rather just move all the
> > documentation and FAQ into the kernel source itself, especially since it
> > all now lives on https://www.kernel.org/doc/html/latest/ ...
> 
> yeah ...
> 
> As a general PSA, the wiki is known to be bitrotting.  It's impossible to add
> new editors, for example.  It'll eventually probably go away entirely.
> 
> I've fixed up a couple things Darrick asked me to do, but maybe we should
> just put a big <blink>THIS WIKI IS BITROTTING</blink> at the top and be
> done with it.

+1 I volunteered myself to take care of the wiki past year, but looks like my
write access requests were completely ignored and well.

On the other hand though, I wonder if everything xfs.org currently has, is worth
to actually move them to kernel sources.

There are a lot of interesting links there (well, the documents itself, not the
links), which IMHO are really worth to keep.

> 
> -Eric
> 
> > --D
> > 
> >> TL;DR:
> >> Please make sure the XFS development is more visible by ensuring that most
> >> prominent references point to the current repository and website.
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
