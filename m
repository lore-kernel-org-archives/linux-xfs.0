Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753285AbdKNSDK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 13:03:10 -0500
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com [209.85.128.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25F0E21929
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2017 18:03:10 +0000 (UTC)
Received: by mail-wr0-f179.google.com with SMTP id l8so18238773wre.12
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2017 10:03:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171112192142.614461013@linutronix.de>
References: <20171112191821.240484206@linutronix.de> <20171112192142.614461013@linutronix.de>
From: Rob Herring <robh@kernel.org>
Date: Tue, 14 Nov 2017 12:02:48 -0600
Message-ID: <CABGGisx5SNMbCmkxS+BqDo723nT3D-gFqLzyonH3Y9Z5zNLeUQ@mail.gmail.com>
Subject: Re: [patch 2/7] LICENSES: Add the GPL 2.0 license
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Kate Stewart <kstewart@linuxfoundation.org>

On Sun, Nov 12, 2017 at 1:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Add the full text of the GPL 2.0 license to the kernel tree.  It was
> copied directly from:
>
>    https://spdx.org/licenses/GPL-2.0.html#licenseText
>
> Add the required tags for reference and tooling.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Greg KH <gregkh@linuxfoundation.org>
> Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>
> Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
>
> ---
>  LICENSES/preferred/GPL-2.0 |  342 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 342 insertions(+)
>  create mode 100644 LICENSES/GPL-2.0

Do we need 2 copies? Here and in COPYING?

Rob
