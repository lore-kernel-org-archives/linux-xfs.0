Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45334 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbfBCIMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Feb 2019 03:12:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3C9632C834
        for <linux-xfs@vger.kernel.org>; Sun,  3 Feb 2019 08:12:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Sun, 03 Feb 2019 08:12:13 +0000
Message-ID: <bug-202441-201763-E9wjyFGYlx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #27 from Roger (rogan6710@gmail.com) ---
I've done testing on distribution standard 4.19.19 "generic" kernel with the
reverts applied, all seems ok again :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
