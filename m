Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45020 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729805AbeGQUcw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jul 2018 16:32:52 -0400
Date: Tue, 17 Jul 2018 19:58:39 +0000
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [RESEND][PATCH v4 0/2] vfs: better dedupe permission check
Message-ID: <20180717195839.GD10690@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180717190906.31073-1-mfasheh@suse.de>
 <20180717194818.GV32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717194818.GV32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>

On Tue, Jul 17, 2018 at 12:48:18PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 17, 2018 at 12:09:04PM -0700, Mark Fasheh wrote:
> > From: Mark Fasheh <mfasheh@suse.de>
> > 
> > [PATCH] ioctl_fideduperange.2: clarify permission requirements
> > 
> > dedupe permission checks were recently relaxed - update our man page to
> > reflect those changes.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > ---
> >  man2/ioctl_fideduperange.2 | 8 +++++---
> 
> Mmm, man page update, thank you for editing the documentation too!

No problem, thanks for suggesting I do it.


> Please cc linux-api and Michael Kerrisk so this can go upstream.

Will do. The changes you point out below all look good to me so I'll
incorporate them and send an updated version to the appropriate folks.

Thanks
	--Mark

