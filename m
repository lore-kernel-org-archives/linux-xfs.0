Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:41042 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbeA2Vvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 16:51:37 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
References: <1517228795.5965.24.camel@redhat.com> <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Jan 2018 13:51:35 -0800
Message-ID: <CA+55aFzRMS15X7ujHJB2tmFVOteCEgLPB7ysyD+fkRF9dLFaHQ@mail.gmail.com>
Subject: Re: [GIT PULL] inode->i_version rework for v4.16
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: open list <linux-kernel@vger.kernel.org>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs <linux-xfs@vger.kernel.org>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Mon, Jan 29, 2018 at 1:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. I have pulled this, but it is really really broken in one place,
> to the degree that I always went "no, I won't pull this garbage".

always=almost.

I'd blame auto-correct, but I'm not on the phone.

                Linus
