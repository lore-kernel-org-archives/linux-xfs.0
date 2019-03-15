Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:43632 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfCOAOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 20:14:44 -0400
Received: by mail-io1-f68.google.com with SMTP id y6so6760202ioq.10
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 17:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <155259742281.31886.17157720770696604377.stgit@magnolia> <155259744781.31886.15637750109545213350.stgit@magnolia>
In-Reply-To: <155259744781.31886.15637750109545213350.stgit@magnolia>
From: Nathan Scott <nathans@redhat.com>
Date: Fri, 15 Mar 2019 11:14:32 +1100
Message-ID: <CAFMei7N0xs69bVH03FecvFQr6s1M=1MH6JvMjjxcXQMisbUYCw@mail.gmail.com>
Subject: Re: [PATCH 04/36] debian: drop dangling libhandle.a symlinks in xfslibs-dev
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Sandeen, Eric" <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 15, 2019 at 8:04 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> We don't ship static libhandle libraries anymore, so make sure we drop
> the symlink.
>
> Fixes: ec1cf08dbeb2d ("Several updates to use more modern Debian packaging")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

LGTM.

Reviewed-by: Nathan Scott <nathans@debian.org>

cheers.

--
Nathan
