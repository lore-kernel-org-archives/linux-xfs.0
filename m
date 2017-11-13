Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33274 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdKMM0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 07:26:14 -0500
Date: Mon, 13 Nov 2017 13:26:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [1/7] Documentation: Add license-rules.rst to describe how to
 properly identify file licenses
In-Reply-To: <CAFGhKbyJheVH-qrh3jYfWyTjSzFeY2yUJGYuscqLQf+SsvEzqA@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1711131324170.1851@nanos>
References: <20171112192142.525567667@linutronix.de> <CAFGhKbyJheVH-qrh3jYfWyTjSzFeY2yUJGYuscqLQf+SsvEzqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Charlemagne Lasse <charlemagnelasse@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Mon, 13 Nov 2017, Charlemagne Lasse wrote:
> > +If a specific tool cannot handle the standard comment style, then the
> > +appropriate comment mechanism which the tool accepts shall be used.
> 
> Most of the things sound good. But I really don't get the first-line
> thing and the C++ single line comments in C sources.

That's been a decision from Linus and probably not going to change, even if
you argue in circles.

Thanks,

	tglx
