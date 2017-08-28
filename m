Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38484 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdH1OkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 10:40:10 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so4946732wmt.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 07:40:10 -0700 (PDT)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 28 Aug 2017 16:39:48 +0200
Message-ID: <CACj3i71iYMn8+nwUmXUHfR-c2c8XdqfdTsgx5Ohkb2k1FXUd0w@mail.gmail.com>
Subject: My thesis about mkfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi guys

This email is about my thesis I did and which I'm sending you in case
you are interested: Refactoring and Verification of the Code of
mkfs.xfs

The refactoring part (intro and summary of chapter 3) can be somehow
interesting if you want to get a small overview of how it feels to
just jump into a project like this without any experience in regular
development of bigger open source projects (bigger than 1-2 man
shows). Other than that, you won't find there much.

The testing part (chapters 5 and 6) shows how CppCheck, Coverity, and
GCC and Clang compares to each other, in various levels of
aggressiveness. Spoiler: Coverity is pretty good and we are doing well
that we use it. :-)

I'm sorry I didn't publish it right after the defence; I wanted to go
through it and make some minor edits, but in the weeks since the
defence, I forgot what they told me, so I decided I will just send it
as it is, with no other delays. :-)

The thesis was defended and I got a master degree, but I still
appreciate any comments. :-)


Download here:
https://github.com/jtulak/thesis-mmm/releases



Cheers,
Jan

PS: Eric, I hope I didn't overlook anything you pointed out in the
proofreading. Thank you once more for that. :-)
