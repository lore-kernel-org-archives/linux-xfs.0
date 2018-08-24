Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36794 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbeHXQyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 12:54:09 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 04BE22C441
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 13:19:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200923] out-of-bounds access in xfs_iext_last()
Date: Fri, 24 Aug 2018 13:19:31 +0000
Message-ID: <bug-200923-201763-a51Gn3qhuK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200923-201763@https.bugzilla.kernel.org/>
References: <bug-200923-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200923

--- Comment #1 from Wen Xu (wen.xu@gatech.edu) ---
Created attachment 278067
  --> https://bugzilla.kernel.org/attachment.cgi?id=278067&action=edit
The (compressed) crafted image which causes crash

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
