Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f41.google.com ([209.85.210.41]:34820 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeLCOdg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 09:33:36 -0500
Received: by mail-ot1-f41.google.com with SMTP id 81so11769800otj.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Dec 2018 06:32:22 -0800 (PST)
MIME-Version: 1.0
From: Vincenzo Romano <vincenzo.romano@notorand.it>
Date: Mon, 3 Dec 2018 15:31:46 +0100
Message-ID: <CAHjZ2x7pVC+XU2BqXk2O4mEHAcH8bPsJzZsSdvBHqhCiMd0OQw@mail.gmail.com>
Subject: [QUESTION] XFS inode allocation policy
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all.
I am trying to recover a Linux XFS file system that has been partially
overwritten in its beginning part with an improper run of dd (disk
dump).
The original FS had been created from scratch (mkfs.xfs) and then
filled with a single TAR file.
I'd need to be pointed to the proper documentation (if any) to better
understand how the disk space has been used while writing that TAR
file.
I aim to reconstruct the surviving inode list to try to rescue as much
as possible of that TAR file.

Many thanks in advance.

-- 
Vincenzo Romano - NotOrAnd.IT
Information Technologies
--
NON QVIETIS MARIBVS NAVTA PERITVS
