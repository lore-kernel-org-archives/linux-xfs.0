Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36455 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfAINxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jan 2019 08:53:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so8297201wmc.1
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jan 2019 05:53:33 -0800 (PST)
MIME-Version: 1.0
References: <20181101104732.19322-1-jtulak@redhat.com> <1a662234-f71a-7208-76f9-9f2f89aa8255@sandeen.net>
 <c9bea20c-058c-d715-8b2b-9ac55e77c131@sandeen.net>
In-Reply-To: <c9bea20c-058c-d715-8b2b-9ac55e77c131@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 9 Jan 2019 14:53:21 +0100
Message-ID: <CACj3i702aS2Dw_i_8PAGOD6=AFYCuuHqf3EkUop5nhmKoo317A@mail.gmail.com>
Subject: Re: [PATCH] xfsdump: don't fail installation if /sbin is symlink of /usr/sbin
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 5, 2018 at 5:56 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 12/4/18 10:48 PM, Eric Sandeen wrote:
> > On 11/1/18 5:47 AM, Jan Tulak wrote:

snip

> >
> > so, um, I guess this seems ok to handle the /sbin == /usr/sbin case.
> >
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
> Heh, ok, yes your fix is what I should have done 6 years ago :D
>
> Thanks,
> -Eric

This is not merged yet. Maybe it just got off your list somehow? :-)

Cheers
Jan
