Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45344 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755462AbdKNTFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 14:05:10 -0500
Date: Tue, 14 Nov 2017 20:05:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch 2/7] LICENSES: Add the GPL 2.0 license
Message-ID: <20171114190515.GB2326@kroah.com>
References: <20171112191821.240484206@linutronix.de>
 <20171112192142.614461013@linutronix.de>
 <CABGGisx5SNMbCmkxS+BqDo723nT3D-gFqLzyonH3Y9Z5zNLeUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABGGisx5SNMbCmkxS+BqDo723nT3D-gFqLzyonH3Y9Z5zNLeUQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Tue, Nov 14, 2017 at 12:02:48PM -0600, Rob Herring wrote:
> On Sun, Nov 12, 2017 at 1:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Add the full text of the GPL 2.0 license to the kernel tree.  It was
> > copied directly from:
> >
> >    https://spdx.org/licenses/GPL-2.0.html#licenseText
> >
> > Add the required tags for reference and tooling.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Reviewed-by: Greg KH <gregkh@linuxfoundation.org>
> > Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>
> > Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
> >
> > ---
> >  LICENSES/preferred/GPL-2.0 |  342 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 342 insertions(+)
> >  create mode 100644 LICENSES/GPL-2.0
> 
> Do we need 2 copies? Here and in COPYING?

Let's worry about moving the COPYING one _after_ this patch series gets
merged :)

thanks,

greg k-h
