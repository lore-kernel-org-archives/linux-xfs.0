Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49396 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbfGIEk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 00:40:56 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 31EB2284C3
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2019 04:40:56 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204031] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
Date: Tue, 09 Jul 2019 04:40:55 +0000
Message-ID: <bug-204031-201763-gHzs97LnrS@https.bugzilla.kernel.org/>
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

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Updata: By merging above patches, I can't reproduce this bug by running
generic/475 on six different machines 3 days.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
