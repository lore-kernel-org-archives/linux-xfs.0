Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdLEHgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 02:36:13 -0500
Date: Tue, 5 Dec 2017 08:36:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch V4 02/11] LICENSES: Add the GPL 2.0 license
Message-ID: <20171205073620.GB15358@kroah.com>
References: <20171204211927.673291734@linutronix.de>
 <20171204212120.575886112@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171204212120.575886112@linutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Mon, Dec 04, 2017 at 10:19:29PM +0100, Thomas Gleixner wrote:
> Add the full text of the GPL 2.0 license to the LICENSES directory.  It was
> copied directly from the COPYING file in the kernel source tree as it
> differs from the public available version of the license in various places
> including the FSF.
> 
> Philippe did some research on the GPL2.0 history:
> 
>   There is NO trustworthy version of an official GPL 2.0 text: the FSF
>   official texts are all fubar (if only in small and subtle ways). The FSF
>   texts should be authoritative, but then which one? They published more
>   GPL 2.0 versions than most. So we would be hard pressed to blame SPDX or
>   the OSI for having their own minor variant.
> 
>   Then in digging further, I found the ONE true original GPL with a file
>   time stamp on June 2 1991, 01:50 (AM?, PM? unknown time zone?)  ! in an
>   old GCC archive.
> 
>   For the posterity and everyone's enjoyment I have built a git history
>   of GPL 2.0 Mark1 to Mark6
> 
>   See https://github.com/pombredanne/gpl-history/commits/master/COPYING
> 
>   I also added a shorter history of the Linux COPYING text. The first
>   version in Linus's git tree is based on the very fine and well tuned GPL
>   2 Mark4, the first fully Y2K compliant version of the GPL 2, as you can
>   see from the diffs with the former Mark3: that was dangerously stuck in
>   the last century.
> 
>   The current version in is based on a rare GPL 2.0 Mark5.1 aka "Franklin
>   St", that I do not have in my history yet and spells "Franklin St."
>   rather than "Franklin Street."  Therefore there is likely another GPL 2.0
>   version between Mark4 and Mark5 that I have yet to find and may not have
>   been caught by the archive.org spiders. Here help and patches welcomed:
>   this is likely an important missing link.
> 
>   Further information about this archaelogical research;
>   
>   http://lkml.kernel.org/r/CAOFm3uEzRMf261+O-Nm+9HDoEn9RbFjH=5J9i1C2GgMUg2G4LA@mail.gmail.com
> 
> Add the required tags for reference and tooling.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
