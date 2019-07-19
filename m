Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727603AbfGSV2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 17:28:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BA6182892A
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2019 21:28:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date: Fri, 19 Jul 2019 21:28:47 +0000
Message-ID: <bug-204223-201763-sg1Gc6zQFK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204223-201763@https.bugzilla.kernel.org/>
References: <bug-204223-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204223

Luis Chamberlain (mcgrof@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|CODE_FIX                    |---

--- Comment #7 from Luis Chamberlain (mcgrof@kernel.org) ---
Not fixed yet, it just takes longer with this commit to trigger.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
