Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42020 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0Py6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 11:54:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id k13so1207209pgq.9
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 08:54:58 -0700 (PDT)
Date: Thu, 27 Jun 2019 15:54:55 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on
 xfs
Message-ID: <20190627155455.GA30113@42.do-not-panic.com>
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alvin Zheng <Alvin@linux.alibaba.com>
Cc: gregkh <gregkh@linuxfoundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, bfoster@redhat.com, "joseph.qi" <joseph.qi@linux.alibaba.com>, caspar <caspar@linux.alibaba.com>

On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> Hi,
> 
>     I  was using kernel v4.19.y and found that it cannot pass the
> generic/538 due to data corruption. I notice that upstream has fix this
> issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> backport this patch?

Hey Alvin,

Thanks for Bringing this to attention.  I'll look into this a bit more.
Time for a new set of stable fixes for v4.19.y. Of course, I welcome
Briant's feedback, but if he's busy I'll still look into it.

  Luis
