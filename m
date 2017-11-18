Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34728 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162069AbdKRTOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Nov 2017 14:14:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
References: <20171116183306.103584007@linutronix.de> <20171116184358.475929943@linutronix.de>
 <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Nov 2017 11:14:00 -0800
Message-ID: <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Charlemagne Lasse <charlemagnelasse@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

You may be confusing things because of a newer version.

On Sat, Nov 18, 2017 at 11:03 AM, Charlemagne Lasse
<charlemagnelasse@gmail.com> wrote:
>
> That should be "GNU Lesser General Public" and not "GNU Library General Public"

That's just FSF revisionism.

It used to be called "Library" over "Lesser", in the original GPL2.

I suspect your other issues are similar "there's been different
versions over time" things. the address being one of them.

We've actually taken some of the FSF updates over the years ("19yy" ->
"<year>", and the address change) but the main COPYING file still
calls the LGPL the "GNU Library General Public License".

I refuse to change the original copyright wording due to idiotic
internal FSF politics that tried to change history.

             Linus
