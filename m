Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34438 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbfF0Sfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 14:35:51 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 01D8F28475
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 18:35:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Thu, 27 Jun 2019 18:35:50 +0000
Message-ID: <bug-203947-201763-ZH0zw1V4gM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #3 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Meant to say "...can you apply it and retest generic/475?"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
