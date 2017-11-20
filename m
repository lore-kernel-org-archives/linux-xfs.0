Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:57814 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751312AbdKTPbb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 10:31:31 -0500
Date: Mon, 20 Nov 2017 15:31:05 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Message-ID: <20171120153105.38d2b892@alans-desktop>
In-Reply-To: <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com>
References: <20171116183306.103584007@linutronix.de>
        <20171116184358.475929943@linutronix.de>
        <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
        <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Charlemagne Lasse <charlemagnelasse@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Sat, 18 Nov 2017 11:14:00 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> You may be confusing things because of a newer version.
> 
> On Sat, Nov 18, 2017 at 11:03 AM, Charlemagne Lasse
> <charlemagnelasse@gmail.com> wrote:
> >
> > That should be "GNU Lesser General Public" and not "GNU Library General Public"  
> 
> That's just FSF revisionism.
> 
> It used to be called "Library" over "Lesser", in the original GPL2.
> 
> I suspect your other issues are similar "there's been different
> versions over time" things. the address being one of them.
> 
> We've actually taken some of the FSF updates over the years ("19yy" ->
> "<year>", and the address change) but the main COPYING file still
> calls the LGPL the "GNU Library General Public License".
> 
> I refuse to change the original copyright wording due to idiotic
> internal FSF politics that tried to change history.

Do we have any files which had the later LGPL text attached to them - if
so then they should be keeping that header.

Which raises another question. If there are multiple GPL 2.0 texts which
are *supposedly* legally identical but this has never been tested in law
-that implies SPDX is wrong in tagging them identically in case they turn
out not to be...

Alan
