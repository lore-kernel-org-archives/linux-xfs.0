Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f44.google.com ([209.85.166.44]:38513 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfD3V0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 17:26:16 -0400
Received: by mail-io1-f44.google.com with SMTP id y6so13520630ior.5
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2019 14:26:16 -0700 (PDT)
MIME-Version: 1.0
From: Michael Allison <trailhounds@gmail.com>
Date: Tue, 30 Apr 2019 16:26:04 -0500
Message-ID: <CA+nYfY_TkSbXZ5kCbAeQN-PthsV5suomdrMqJ3H0tbNx2ZQ3xQ@mail.gmail.com>
Subject: XFS performance decrease as filesystem approaches full
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,


Many filesystems begin to show decreased performance as the available
free space in the defined filesystem approaches the maximum available
blocks. Are there any guidelines about this sort of performance drag
available for XFS?


Thanks,


Mike

michael allison | 303-817-9002 | My LinkedIn Profile
