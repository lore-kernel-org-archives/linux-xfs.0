Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33782 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbeLLJ2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 04:28:48 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3A8B52AB61
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 09:28:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201973] New: File Size
Date: Wed, 12 Dec 2018 09:28:47 +0000
Message-ID: <bug-201973-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201973

            Bug ID: 201973
           Summary: File Size
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.0-862.el7.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: ghasemsystem@gmail.com
        Regression: No

Created attachment 279965
  --> https://bugzilla.kernel.org/attachment.cgi?id=279965&action=edit
file size

hi
when my log file is used by program and i truncate it, file size is release on
disk but ll/ls command show old size of file, but du command work correctly

good luck

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
