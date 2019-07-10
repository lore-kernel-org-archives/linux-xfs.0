Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34123 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfGJQsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 12:48:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so3232135wrm.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru> <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru> <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
In-Reply-To: <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Jul 2019 10:47:55 -0600
Message-ID: <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: Andrey Zhunev <a-j@a-j.ru>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 10, 2019 at 10:46 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> # smartctl -l scterc,900,100
> # echo 180 > /sys/block/sda/device/timeout


smartctl command above does need a drive specified...



-- 
Chris Murphy
