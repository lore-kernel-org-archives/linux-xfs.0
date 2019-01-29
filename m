Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46520 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727342AbfA2WDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 17:03:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7A5FB2DCB7
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 22:03:23 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Tue, 29 Jan 2019 22:03:22 +0000
Message-ID: <bug-202349-201763-vNbwCNRDVh@https.bugzilla.kernel.org/>
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

--- Comment #10 from Dave Chinner (david@fromorbit.com) ---
Hi nfxjfg,

Can you try a plain 4.19.0 kernel and see if it has the same problem? I suspect
not, read https://bugzilla.kernel.org/show_bug.cgi?id=202441 for more details.
I'd like to confirm that this is the same issue.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
