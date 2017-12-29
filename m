Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:38445 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750869AbdL2QUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Dec 2017 11:20:05 -0500
Message-ID: <1514564399.10256.7.camel@perches.com>
Subject: Re: [patch V5 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
From: Joe Perches <joe@perches.com>
Date: Fri, 29 Dec 2017 08:19:59 -0800
In-Reply-To: <CAOFm3uG_Sj1+jf32CvCeuWZV_nK1f-8B6POd_nZXAEJghnB08w@mail.gmail.com>
References: <20171228152710.891701433@linutronix.de>
         <20171228153308.286787253@linutronix.de>
         <alpine.DEB.2.20.1712282315030.1899@nanos>
         <CAOFm3uG_Sj1+jf32CvCeuWZV_nK1f-8B6POd_nZXAEJghnB08w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philippe Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Fri, 2017-12-29 at 14:21 +0100, Philippe Ombredanne wrote:
> Thomas,
> 
> On Thu, Dec 28, 2017 at 11:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 28 Dec 2017, Thomas Gleixner wrote:
> > 
> > Sorry for the spam. I somehow missed to refresh the patch before generating
> > the mbox. Find below the correct version of that one which has ALL braces
> > removed which we don't need.

Has it been legally reviewed and accepted that removal
of the BSD license text from individual source files is
appropriate and meets the legal requirements of
following the BSD license on a per-file basis?

And if so, who did this review?

Is there any license that does not allow removal of the
license text and does not allow simple substitution of
the SPDX license identifier in each individual file?
