Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbdIROXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 10:23:08 -0400
Date: Mon, 18 Sep 2017 16:23:16 +0200
From: gregkh <gregkh@linuxfoundation.org>
Subject: Re: stable-rc/linux-4.13.y build: 208 builds: 0 failed, 208 passed,
 29 warnings (v4.13.2-53-gb857b6dfc252)
Message-ID: <20170918142316.GC12458@kroah.com>
References: <59bfa691.4c3e1c0a.a7b17.e9df@mx.google.com>
 <CAK8P3a0LYQ8ZRxcPJNOC0++C2D=vG0X1=RVyJssBAjNzmaEaLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0LYQ8ZRxcPJNOC0++C2D=vG0X1=RVyJssBAjNzmaEaLw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "kernelci.org bot" <bot@kernelci.org>, Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, stable <stable@vger.kernel.org>

On Mon, Sep 18, 2017 at 04:19:08PM +0200, Arnd Bergmann wrote:
> On Mon, Sep 18, 2017 at 12:57 PM, kernelci.org bot <bot@kernelci.org> wrote:
> >
> > stable-rc/linux-4.13.y build: 208 builds: 0 failed, 208 passed, 29 warnings (v4.13.2-53-gb857b6dfc252)
> 
> Same as v4.9, please backport
> 
> 7bf7a193a90c ("xfs: fix compiler warnings")

Now applied, thanks.

greg k-h
