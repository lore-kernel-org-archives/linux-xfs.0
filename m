Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38424 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754316AbdKNKPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 05:15:33 -0500
Date: Tue, 14 Nov 2017 10:15:16 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [patch 0/7] LICENSES: Add documentation and initial License files
Message-ID: <20171114101516.GN12318@n2100.armlinux.org.uk>
References: <20171112191821.240484206@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171112191821.240484206@linutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org

On Sun, Nov 12, 2017 at 08:18:21PM +0100, Thomas Gleixner wrote:
> Folks!
> 
> First of all I want to apologize for the suboptimal process which brought
> this initial SPDX annotation into the kernel. We surely should have posted
> exactly this patch series first, but we were too focused on the actual
> annotation and analysis work, which took place in the last 10 months. As is
> happens often with work which occupies one on the 'technical' level
> completely, documentation is the last thing to think of.

Hi Thomas,

Thank you for doing this, this addresses many of my concerns with the
SPDX license tagging.  For the series:

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

As for the comment style, I'm sure that we'll eventually learn to use
the appropriate style for the file type, but I suspect it won't be
easy as it's not intuitive.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
