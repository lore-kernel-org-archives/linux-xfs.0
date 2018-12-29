Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57844 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbeL2GTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Dec 2018 01:19:39 -0500
Date: Sat, 29 Dec 2018 07:19:35 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 00/20] drop useless LIST_HEAD
In-Reply-To: <20181229052504.GA16315@magnolia>
Message-ID: <alpine.DEB.2.21.1812290717010.2673@hadrien>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr> <CAKR_QVJefW1vxYb7-qiU8=0YdbFghYo15SK2eGjOC-dntRfyYA@mail.gmail.com> <alpine.DEB.2.21.1812232304130.2940@hadrien> <CAKR_QVLeZBL43W4x1mzcfcakSZyyh9L81vgUMxfnSccKawEfdg@mail.gmail.com>
 <20181227134055.GA2272@kadam> <20181229052504.GA16315@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Tom Psyborg <pozega.tomislav@gmail.com>, Julia Lawall <julia.lawall@lip6.fr>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-janitors@vger.kernel.org, dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org, linux-wireless@vger.kernel.org



On Fri, 28 Dec 2018, Darrick J. Wong wrote:

> On Thu, Dec 27, 2018 at 04:40:55PM +0300, Dan Carpenter wrote:
> > On Tue, Dec 25, 2018 at 11:12:20PM +0100, Tom Psyborg wrote:
> > > there was discussion about this just some days ago. CC 4-5 lists is
> > > more than enough
> > >
> >
> > I don't know who you were discussing this with...
> >
> > You should CC the 0th patch to all the mailinglists.  That much is a
> > clear rule.
> >
> > For the rest, Julia's position is the more conservative one.  I was in
> > a conversation in RL and they were like, "CC everyone for all the
> > patches".  It depends on the context, of course.  If the patches are
> > dependent on each other then you *have* to CC everyone for everything.
>
> Agreed.  Ms. Lawall, sending "Cover letter + all relevant XFS patches"
> (as you did) was exactly the right thing for us xfs types. :)
>
> For that matter, we prefer to receive through linux-xfs more patches
> than necessary (one can send the entire series if one is unsure) than to
> go wanting for more context.

Thanks for the confirmation.  I was planning to ignore the 4-5 advice,
because there is no way in this case to make a meaningful 4-5 list
suggestion - it's either all or nothing.  But 20 patches at once is
perhaps a lot as well.  In this case, I just wanted to get rid of the
whole issue at once.

julia
