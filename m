Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33888 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdH2W0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 18:26:01 -0400
Received: by mail-io0-f171.google.com with SMTP id n71so26230713iod.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 15:26:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170829221522.GE10621@dastard>
References: <1503956111-36652-1-git-send-email-keescook@chromium.org>
 <1503956111-36652-16-git-send-email-keescook@chromium.org>
 <20170828214957.GJ4757@magnolia> <CAGXu5j+pvxRjASUuBE49+uH34Mw26a4mtcWrZd=CEqcRHjetvA@mail.gmail.com>
 <20170829044707.GP4757@magnolia> <CAGXu5jJX1DA9D1LtrKkNoBXKZEYhbSE148YmUOP=WXsBCFsCyw@mail.gmail.com>
 <20170829221522.GE10621@dastard>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 29 Aug 2017 15:25:59 -0700
Message-ID: <CAGXu5jLh5XKpD3FtJ9Ft25MGziE83f3v7qcRPunh7PWY52YPmA@mail.gmail.com>
Subject: Re: [PATCH v2 15/30] xfs: Define usercopy region in xfs_inode slab cache
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, LKML <linux-kernel@vger.kernel.org>, David Windsor <dave@nullcore.net>, linux-xfs@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

On Tue, Aug 29, 2017 at 3:15 PM, Dave Chinner <david@fromorbit.com> wrote:
> If you are touching multiple filesystems, you really should cc the
> entire patchset to linux-fsdevel, similar to how you sent the entire
> patchset to lkml. That way the entire series will end up on a list
> that almost all fs developers read. LKML is not a list you can rely
> on all filesystem developers reading (or developers in any other
> subsystem, for that matter)...

Okay, sounds good. Thanks!

-Kees

-- 
Kees Cook
Pixel Security
