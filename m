Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:48838 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdJFIqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 04:46:21 -0400
Received: by mail-qt0-f171.google.com with SMTP id d13so29431129qta.5
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2017 01:46:21 -0700 (PDT)
MIME-Version: 1.0
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Fri, 6 Oct 2017 10:46:20 +0200
Message-ID: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
Subject: agcount for 2TB, 4TB and 8TB drives
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi to all,
i'm new to XFS.

Which is the proper agcount for 2TB, 4TB and 8TB drives (not part of any RAID) ?

mkfs.xfs automatically choosen 4 AGs. Isn't this too low ?
