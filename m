Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbfHCVHs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Aug 2019 17:07:48 -0400
Date: Sat, 3 Aug 2019 14:07:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [GIT PULL] xfs: cleanups for 5.3-rc3
Message-ID: <20190803210746.GM7138@magnolia>
References: <20190803163312.GK7138@magnolia>
 <CAHk-=wgg8Y=KxZaHy66BdOKKtDzQ_XN4sR6YWa00+v+06azt4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgg8Y=KxZaHy66BdOKKtDzQ_XN4sR6YWa00+v+06azt4A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>

On Sat, Aug 03, 2019 at 10:46:38AM -0700, Linus Torvalds wrote:
> On Sat, Aug 3, 2019 at 9:33 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Here are a couple more bug fixes that trickled in since -rc1.  It's
> > survived the usual xfstests runs and merges cleanly with this morning's
> > master.  Please let me know if anything strange happens.
> 
> Hmm. This was tagged, but not signed like your usual tags are.
> 
> I've pulled it (I don't _require_ signed tags from kernel.org), but
> would generally be much happier if I saw the signing too...

D'oh.  Sorry, I forgot to git tag -a. :(

/me rummages around to see if there's a way to configure git to sign
always...

--D

> Thanks,
> 
>                  Linus
