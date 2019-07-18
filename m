Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44702 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfGRSTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 14:19:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so28281573ljc.11
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 11:19:47 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id r68sm4105691lff.52.2019.07.18.11.19.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 11:19:45 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id x3so19980200lfc.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 11:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190718161824.GE7093@magnolia>
In-Reply-To: <20190718161824.GE7093@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jul 2019 11:19:28 -0700
Message-ID: <CAHk-=whewBiKzpsO73Y38SAPSktxD6gUuEr2ANC8Z_3JPiqk3w@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: cleanups for 5.3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>

On Thu, Jul 18, 2019 at 9:18 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please let me know if you run into anything weird, I promise I drank two
> cups of coffee this time around. :)

Apparently two cups is just the right amount.

                 Linus
