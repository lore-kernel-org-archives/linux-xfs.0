Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:44203 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdIROTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 10:19:10 -0400
MIME-Version: 1.0
In-Reply-To: <59bfa691.4c3e1c0a.a7b17.e9df@mx.google.com>
References: <59bfa691.4c3e1c0a.a7b17.e9df@mx.google.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 18 Sep 2017 16:19:08 +0200
Message-ID: <CAK8P3a0LYQ8ZRxcPJNOC0++C2D=vG0X1=RVyJssBAjNzmaEaLw@mail.gmail.com>
Subject: Re: stable-rc/linux-4.13.y build: 208 builds: 0 failed, 208 passed,
 29 warnings (v4.13.2-53-gb857b6dfc252)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "kernelci.org bot" <bot@kernelci.org>
Cc: Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, gregkh <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>

On Mon, Sep 18, 2017 at 12:57 PM, kernelci.org bot <bot@kernelci.org> wrote:
>
> stable-rc/linux-4.13.y build: 208 builds: 0 failed, 208 passed, 29 warnings (v4.13.2-53-gb857b6dfc252)

Same as v4.9, please backport

7bf7a193a90c ("xfs: fix compiler warnings")

       Arnd
