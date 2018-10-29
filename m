Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32945 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbeJ3DfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 23:35:15 -0400
Received: by mail-lj1-f194.google.com with SMTP id z21-v6so8875531ljz.0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Oct 2018 11:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20181026201943.24131-1-stefanrin@gmail.com> <20181026201943.24131-6-stefanrin@gmail.com>
 <e9fb6661-858a-250a-ec2f-a9232e0309ae@sandeen.net> <CAAxjCEwi5i0B1Gg4fE-KPf3px4zNgvksY_z=RDfwR_=u=5zAEA@mail.gmail.com>
 <e74e127c-e0a0-20e8-f34c-7775bc5f972f@sandeen.net>
In-Reply-To: <e74e127c-e0a0-20e8-f34c-7775bc5f972f@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Mon, 29 Oct 2018 19:45:06 +0100
Message-ID: <CAAxjCEyNGnXTqFBr3xxZNpmhUA8C9EjT=UNPZQC-KCSak2AA1Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] xfs_metadump: Zap dev inodes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 29, 2018 at 7:37 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> sorry, my point was just that it's probably better to explicitly name them
> than to fall through to a default but I forgot about 2 formats.

It's basically down to preference and a choice only you can make.
Either you forget one and do too little, or you forget one and do too
much. If this is the exhaustive list, I believe you ;).
