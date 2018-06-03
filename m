Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:42381 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbeFCWT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 18:19:56 -0400
Received: by mail-qt0-f178.google.com with SMTP id y31-v6so8470644qty.9
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 15:19:55 -0700 (PDT)
MIME-Version: 1.0
From: Wen Xu <xuwen.sjtu@gmail.com>
Date: Sun, 3 Jun 2018 18:19:54 -0400
Message-ID: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
Subject: NULL pointer dereference in xfs_bmap_extents_to_btree() when mounting
 and operating a crafted image
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi XFS developers and maintainers,
Please check: https://bugzilla.kernel.org/show_bug.cgi?id=199915

Thanks,
Wen
