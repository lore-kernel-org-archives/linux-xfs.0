Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47728 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbeHXRKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 13:10:42 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5A09D2C72C
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 13:35:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200925] null pointer dereference in xfs_dir_isempty()
Date: Fri, 24 Aug 2018 13:36:00 +0000
Message-ID: <bug-200925-201763-gMik36fO8b@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200925-201763@https.bugzilla.kernel.org/>
References: <bug-200925-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200925

--- Comment #1 from Wen Xu (wen.xu@gatech.edu) ---
Created attachment 278071
  --> https://bugzilla.kernel.org/attachment.cgi?id=278071&action=edit
The (compressed) crafted image which causes crash

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
