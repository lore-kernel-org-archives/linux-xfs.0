Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54326 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728425AbfASRPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Jan 2019 12:15:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 28B4229C9D
        for <linux-xfs@vger.kernel.org>; Sat, 19 Jan 2019 17:15:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Sat, 19 Jan 2019 17:15:17 +0000
Message-ID: <bug-202349-201763-m5kj0f7GVt@https.bugzilla.kernel.org/>
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

--- Comment #1 from nfxjfg@googlemail.com ---
PS: I've observed absolutely no problems when reformatting exactly the same
target disk with ext4 and performing the same test.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
