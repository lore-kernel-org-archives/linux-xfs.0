Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43000 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728327AbfHHM7P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 08:59:15 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1881D28B3E
        for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2019 12:59:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204031] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
Date: Thu, 08 Aug 2019 12:59:14 +0000
Message-ID: <bug-204031-201763-eVFrNG8mlR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204031-201763@https.bugzilla.kernel.org/>
References: <bug-204031-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204031

billodo@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |billodo@redhat.com

--- Comment #2 from billodo@redhat.com ---
Is the patch given in Comment 9 suitable for upstream submit?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
