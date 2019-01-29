Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39096 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728224AbfA2XDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 18:03:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2E70E2D522
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 23:03:22 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 23:03:21 +0000
Message-ID: <bug-202441-201763-x9fpm8eS4W@https.bugzilla.kernel.org/>
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

--- Comment #21 from Roger (rogan6710@gmail.com) ---
Worked very well :) (compile took 3min 31s) 
I saw the same behaviour as I first noticed on rc5, sawtoothing buff/cache.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
