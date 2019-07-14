Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f54.google.com ([209.85.167.54]:43340 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbfGNBRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jul 2019 21:17:50 -0400
Received: by mail-lf1-f54.google.com with SMTP id c19so8736104lfm.10
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jul 2019 18:17:49 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id q1sm2253003ljb.87.2019.07.13.18.17.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 18:17:46 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id v24so12777962ljg.13
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jul 2019 18:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190712180205.GA5347@magnolia> <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
 <20190713040728.GB5347@magnolia>
In-Reply-To: <20190713040728.GB5347@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Jul 2019 18:17:30 -0700
Message-ID: <CAHk-=wgEsUC1uLdYCX6rxGxRcgzKS64e3Y8h5HVLvnpGSj5pJA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new features for 5.3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>

On Fri, Jul 12, 2019 at 9:07 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Doh, it turns out I was merging against the same HEAD as my last two
> pull requests because I forgot to re-pull.  Sorry about that.  It's been
> too long of a week. :/

Heh, no problem, I was just surprised when my merge result didn't
match expectations.

As mentioned, it wasn't like the conflict was complicated, only unexpected.

                     Linus
