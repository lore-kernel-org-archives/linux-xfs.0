Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34494 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbeGOH6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Jul 2018 03:58:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F195A28A22
        for <linux-xfs@vger.kernel.org>; Sun, 15 Jul 2018 07:36:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 199899] Mounting broken XFS partition causes infinite dmesg
 flood (system still responds)
Date: Sun, 15 Jul 2018 07:36:03 +0000
Message-ID: <bug-199899-201763-xKQE8kbU17@https.bugzilla.kernel.org/>
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

Anatoly Trosinenko (anatoly.trosinenko@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #276295|0                           |1
        is obsolete|                            |

--- Comment #3 from Anatoly Trosinenko (anatoly.trosinenko@gmail.com) ---
Created attachment 277357
  --> https://bugzilla.kernel.org/attachment.cgi?id=277357&action=edit
Kernel config

Updated config for v4.18-rc4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.