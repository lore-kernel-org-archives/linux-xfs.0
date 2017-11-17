Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37593 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdKQL7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 06:59:20 -0500
Received: by mail-wr0-f193.google.com with SMTP id k61so1896922wrc.4
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 03:59:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1711171057240.1709@nanos>
References: <20171116183306.103584007@linutronix.de> <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 12:58:38 +0100
Message-ID: <CAOFm3uHBQODoqSfdE-EJWOWxmtpMhbSQMQVBqCri4+T-jYfTbA@mail.gmail.com>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to describe
 how to properly identify file licenses
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Fri, Nov 17, 2017 at 11:00 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Subject: Documentation: Add license-rules.rst to describe how to properly identify file licenses
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 10 Nov 2017 09:30:00 +0100
>
> Add a file to the Documentation directory to describe how file licenses
> should be described in all kernel files, using the SPDX identifier, as well
> as where all licenses should be in the kernel source tree for people to
> refer to (LICENSES/).
>
> Thanks to Kate, Greg and Jonathan for review and editing and Jonas for the
> suggestions concerning the meta tags in the licenses files.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>
> Changes since V3:
>   - Addressed Jonathans review comments
>   - Added .dts{i} syntax (Rob)
>
> ---

For this V4 and all the V2 11 patch series, after using a fine comb....

Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>

-- 
Cordially
Philippe Ombredanne
