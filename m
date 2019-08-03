Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35444 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfHCRq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 13:46:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so75817901ljh.2
        for <linux-xfs@vger.kernel.org>; Sat, 03 Aug 2019 10:46:57 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id j23sm13495473lfb.93.2019.08.03.10.46.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Aug 2019 10:46:55 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id s19so55119414lfb.9
        for <linux-xfs@vger.kernel.org>; Sat, 03 Aug 2019 10:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190803163312.GK7138@magnolia>
In-Reply-To: <20190803163312.GK7138@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 3 Aug 2019 10:46:38 -0700
Message-ID: <CAHk-=wgg8Y=KxZaHy66BdOKKtDzQ_XN4sR6YWa00+v+06azt4A@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: cleanups for 5.3-rc3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>

On Sat, Aug 3, 2019 at 9:33 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Here are a couple more bug fixes that trickled in since -rc1.  It's
> survived the usual xfstests runs and merges cleanly with this morning's
> master.  Please let me know if anything strange happens.

Hmm. This was tagged, but not signed like your usual tags are.

I've pulled it (I don't _require_ signed tags from kernel.org), but
would generally be much happier if I saw the signing too...

Thanks,

                 Linus
