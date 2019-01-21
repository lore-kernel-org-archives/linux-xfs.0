Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36256 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729413AbfAUQQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 11:16:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C8BE52A713
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jan 2019 16:16:35 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Mon, 21 Jan 2019 16:16:35 +0000
Message-ID: <bug-202349-201763-12H8qufWoB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

--- Comment #4 from nfxjfg@googlemail.com ---
I'll try to provide all this information in a few days.

I doubt I'll be able to trigger the sysrq with a shell command while the system
is frozen (because, well, it's frozen). If that's the case, would triggering
the sysrq via keyboard directly work better?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
