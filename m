Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f169.google.com ([209.85.208.169]:46175 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbeKCBnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 21:43:25 -0400
Received: by mail-lj1-f169.google.com with SMTP id x3-v6so2255240lji.13
        for <linux-xfs@vger.kernel.org>; Fri, 02 Nov 2018 09:35:42 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id a19-v6sm5114937ljj.91.2018.11.02.09.35.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 09:35:40 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id x85-v6so2304327ljb.2
        for <linux-xfs@vger.kernel.org>; Fri, 02 Nov 2018 09:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20181102051459.GS6311@dastard>
In-Reply-To: <20181102051459.GS6311@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2018 09:35:23 -0700
Message-ID: <CAHk-=whrpyMSWM4wxYE+E4fSbpkD3yBATjLnzvvAKBfhGwUaAw@mail.gmail.com>
Subject: Re: [GIT PULL] vfs: fix many problems in vfs clone/dedupe implementation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: djwong@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Thu, Nov 1, 2018 at 10:15 PM Dave Chinner <david@fromorbit.com> wrote:
>
> Can you please pull update containing a rework of the VFS clone and
> dedupe file range infrastructure from the tag listed below?

I don't love the timing of this at the end of the merge window, but pulled,

                Linus
