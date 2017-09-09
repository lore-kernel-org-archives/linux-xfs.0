Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33114 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757228AbdIICN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 22:13:57 -0400
Received: by mail-pf0-f194.google.com with SMTP id h4so2231182pfk.0
        for <linux-xfs@vger.kernel.org>; Fri, 08 Sep 2017 19:13:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0067e494-4404-f808-ff72-ee89ec60aecb@sandeen.net>
References: <20170909015832.32424-1-raj.khem@gmail.com> <0067e494-4404-f808-ff72-ee89ec60aecb@sandeen.net>
From: Khem Raj <raj.khem@gmail.com>
Date: Fri, 8 Sep 2017 19:13:26 -0700
Message-ID: <CAMKF1soN5rfgoT44o2cWKe2GtETwF8ff7F0=5wGVHSajCLbE4w@mail.gmail.com>
Subject: Re: [PATCH] xfsprogs: remove remaining double-underscore integer types
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 8, 2017 at 7:06 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 9/8/17 8:58 PM, Khem Raj wrote:
>>  This is a purely mechanical patch that removes the private
>>     __{u,}int{8,16,32,64}_t use in favor of using the system
>>     provided {u,}int{8,16,32,64}_t typedefs.
>
> As mentioned, this is already present on the for-next branch of xfsprogs-dev:
>
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?h=for-next&id=4a492e72515509ee702286a42afe7d8f89d37636

indeed, 2 cherry-picks helped. Ignore this one.
have a nice one.
