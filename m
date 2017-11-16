Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47306 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933329AbdKPSDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 13:03:49 -0500
Date: Thu, 16 Nov 2017 19:03:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/7] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
In-Reply-To: <20171116151540.GA18500@silk.coyote.org>
Message-ID: <alpine.DEB.2.20.1711161855380.2109@nanos>
References: <20171112191821.240484206@linutronix.de> <20171112192142.525567667@linutronix.de> <20171116080723.279591c8@lwn.net> <20171116151540.GA18500@silk.coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonas Oberg <jonas@fsfe.org>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Thu, 16 Nov 2017, Jonas Oberg wrote:
> > One other thing that occurred to me is that documentation files, too,
> > are copyrightable and should have license identifiers.
> 
> Would it make sense to take an incremental approach to this? Get the
> source code and identifiers worked on by Thomas et al through first, then
> think about and fix up potential other issues, like the top level COPYING
> file, or documentation :-)

The top level COPYING file is historic, in terms of computer age even
palaeontologic. We can't fix it :)

Thanks,

	tglx
