Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35176 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbeGOIOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Jul 2018 04:14:50 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0F3D42898D
        for <linux-xfs@vger.kernel.org>; Sun, 15 Jul 2018 07:52:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 199899] Mounting broken XFS partition causes infinite dmesg
 flood (system still responds)
Date: Sun, 15 Jul 2018 07:52:48 +0000
Message-ID: <bug-199899-201763-09wyQuq8E3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199899-201763@https.bugzilla.kernel.org/>
References: <bug-199899-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=199899

--- Comment #4 from Anatoly Trosinenko (anatoly.trosinenko@gmail.com) ---
Reproducible on xfs-linux/for-next (commit efe80327)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.