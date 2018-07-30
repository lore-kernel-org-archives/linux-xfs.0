Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731760AbeGaAHz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 20:07:55 -0400
Date: Mon, 30 Jul 2018 15:30:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Clearly state infrastructure change on old XFS website
Message-ID: <20180730223042.GC4226@magnolia>
References: <4b3ef7f54f32dc2b61a5d4a33a0e5b2e@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3ef7f54f32dc2b61a5d4a33a0e5b2e@wh2.tu-dresden.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: adam_kalisz <adam_kalisz@wh2.tu-dresden.de>
Cc: david@fromorbit.com, linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Jul 28, 2018 at 11:25:40PM +0200, adam_kalisz wrote:
> Dear Darrick,
> 
> I wanted to have a look at the recent new features being added to XFS and
> stumbled on the fact, that Google presents me first with the old website [0]
> and starting on page 2 of the web results (for the desperate) with the
> current website [1].
> 
> It would be most helpful to write some notice to the old website and the
> "Getting the latest source code" should point to the current git-repo. It
> cost me some time to realize, there is something wrong, because the git log
> ended at about 4.9 kernel (~2016) when the infrastructure from sgi probably
> got left behind. Also maybe highlight, that the current repo ist xfs-linux
> and NOT linux-xfs! It might help some of your possible future colleagues to
> get started with XFS.

Sorry about that -- I'll ask those who have write access to xfs.org to
update the links.  In the long run I'd rather just move all the
documentation and FAQ into the kernel source itself, especially since it
all now lives on https://www.kernel.org/doc/html/latest/ ...

--D

> TL;DR:
> Please make sure the XFS development is more visible by ensuring that most
> prominent references point to the current repository and website.
> 
> [0] http://xfs.org/index.php/Main_Page
> [1] https://xfs.wiki.kernel.org/
> 
> Best regards and keep up the good work
> 
> -- 
> Adam Kalisz
