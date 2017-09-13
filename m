Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:48889 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdIMOsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 10:48:41 -0400
Received: by mail-io0-f169.google.com with SMTP id n69so2546886ioi.5
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2017 07:48:41 -0700 (PDT)
MIME-Version: 1.0
From: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Date: Wed, 13 Sep 2017 10:48:40 -0400
Message-ID: <CAGbvivJv=qSRA6Vm2ggjpYcg59gXA0YroYcUHmsJXUfqodtzjQ@mail.gmail.com>
Subject: backport request/question
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Are the recent XFS fixes in the 4.13 kernel planned for backport to
4.12 or 4.9 kernels?

Im specifically interested in "xfs: don't crash on unexpected holes in
dir/attr btrees" as it fixed critical problems triggered by ceph OSD
processes running on XFS disks.


-Wyllys Ingersoll
 Keeper Technology
