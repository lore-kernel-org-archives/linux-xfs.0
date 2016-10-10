Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54981 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbcJJOMk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 10:12:40 -0400
Date: Mon, 10 Oct 2016 10:10:29 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <988281682.41395.1476108629872.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161009215454.GM9806@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com> <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com> <20161007070838.GA16260@quack2.suse.cz> <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com> <1267347639.1072505.1475854075552.JavaMail.zimbra@redhat.com> <1337864351.1107846.1475866582573.JavaMail.zimbra@redhat.com> <20161009215454.GM9806@dastard>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, tj <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Jan Kara" <jack@suse.cz>, "Miklos Szeredi" <miklos@szeredi.hu>, "tj" <tj@kernel.org>, "Al Viro"
> <viro@ZenIV.linux.org.uk>, "Linus Torvalds" <torvalds@linux-foundation.org>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org, "Dave Jones" <davej@codemonkey.org.uk>
> Sent: Sunday, October 9, 2016 5:54:55 PM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> Again, no evidence that the system is actually hung. Waiting on
> locks, yes, but nothing to indicate there is a deadlock in those
> waiters.
Here you are,

http://people.redhat.com/qcai/tmp/dmesg

    CAI Qian
