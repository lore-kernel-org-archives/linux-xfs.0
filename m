Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38023 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbdF2H5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 03:57:04 -0400
Received: by mail-wm0-f43.google.com with SMTP id b184so5207689wme.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2017 00:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170628161828.GG21846@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170628161828.GG21846@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 29 Jun 2017 09:56:41 +0200
Message-ID: <CACj3i73JmBQ-YXCX=eb-jT+fWHWL3m5DgMrM3JJsUjfYwGZ26g@mail.gmail.com>
Subject: Re: [PATCH 00/12] mkfs: save user input into opts table
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jun 28, 2017 at 6:18 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Sun, Apr 23, 2017 at 08:54:51PM +0200, Jan Tulak wrote:
>> Hi guys,
>>
>> I decided to split my big patchset into more smaller ones. So, this is the
>> first set. It adds set/get functions similar to Dave's suggestion, to save and
>> retrieve user values to and from the big opts table and prepares the ground for
>> future patches.
>
> *poke* just curious if you were planning on respining these any time soon.
>
>   Luis

Sure, I was off for some time and focusing on school. I got back few
days ago, so give me a week or two before I get the patchset up to
date...

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
