Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37977 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbdKMNzQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 08:55:16 -0500
Received: by mail-wm0-f52.google.com with SMTP id z3so5180542wme.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2017 05:55:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171112191821.240484206@linutronix.de>
References: <20171112191821.240484206@linutronix.de>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Mon, 13 Nov 2017 14:54:34 +0100
Message-ID: <CAOFm3uFWrk_msv0EozAWRu3Fz8=eMbg7t5kta05ewKpMOUK__A@mail.gmail.com>
Subject: Re: [patch 0/7] LICENSES: Add documentation and initial License files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, xfs <linux-xfs@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>

On Sun, Nov 12, 2017 at 8:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> If you want to create your own scan data, the ScanCode tool can be found
> here:
>
>  https://github.com/nexB/scancode-toolkit.git
>
> It's python based and simple to install and use. Philippe is willing to
> help if there are questions or issues.

I am on deck to help with any question or issue (except for timer and
spinlock questions) e.g. related to license and copyright detection.

Kernel contributor and maintainer requests are treated as priority.
You can contact me directly off list or through the ScanCode tracker.

As a side note, I am toying with an addon [1] that can within reason
remove the detected license boilerplate and replace it with an SPDX
identifier in one pass to help cleanup more of these.

And Thomas: Thank you for the kind words!

[1] https://github.com/nexB/scancode-toolkit/blob/833-espedexify/src/scancode/plugin_espedexify.py

-- 
Cordially
Philippe Ombredanne
