Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:36064 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdKSIug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Nov 2017 03:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAFGhKbzyyKgQ-PyoU-3N_6q5YjvoVMrm9qqtnBS6Vq-EGR2ifA@mail.gmail.com>
References: <20171116183306.103584007@linutronix.de> <20171116184358.475929943@linutronix.de>
 <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
 <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com> <CAFGhKbzyyKgQ-PyoU-3N_6q5YjvoVMrm9qqtnBS6Vq-EGR2ifA@mail.gmail.com>
From: Charlemagne Lasse <charlemagnelasse@gmail.com>
Date: Sun, 19 Nov 2017 09:50:35 +0100
Message-ID: <CAFGhKbwRLzbLiJNQ_=iO1k_+WTbu2kZTR6Tff8LuZyazw0R4iA@mail.gmail.com>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

2017-11-18 21:41 GMT+01:00 Charlemagne Lasse <charlemagnelasse@gmail.com>:
> 2017-11-18 20:14 GMT+01:00 Linus Torvalds <torvalds@linux-foundation.org>:
>> You may be confusing things because of a newer version.
>>
> <cut>
>> I refuse to change the original copyright wording due to idiotic
>> internal FSF politics that tried to change history.
>

<cut>
> And do you even know the best part: it is also not the version from your
> COPYING file.

Let us check the non-whitespace differences (the whitespaces are
completely different in this patch) between the Linux COPYING file
and this patch:

<cut>
> +Copyright (C) 1989, 1991 Free Software Foundation, Inc.
> +51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

This should have been "St." and not "Street"

<cut>
> +TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

"GNU GENERAL PUBLIC LICENSE" missing before
"TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION"

<cut>
> +    One line to give the program's name and a brief idea of what it does.

This should have been

<one line to give the program's name and a brief idea of what it does.>

<cut>
> +    You should have received a copy of the GNU General Public License along
> +    with this program; if not, write to the Free Software Foundation, Inc.,
> +    59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

This should have been:

51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

<cut>
> +    signature of Ty Coon, 1 April 1989

This should have been

  <signature of Ty Coon>, 1 April 1989
