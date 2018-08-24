Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47800 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbeHXRK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 13:10:56 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7289C2C72C
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 13:36:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200925] null pointer dereference in xfs_dir_isempty()
Date: Fri, 24 Aug 2018 13:36:13 +0000
Message-ID: <bug-200925-201763-rc2TY8i8sQ@https.bugzilla.kernel.org/>
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

--- Comment #2 from Wen Xu (wen.xu@gatech.edu) ---
Created attachment 278073
  --> https://bugzilla.kernel.org/attachment.cgi?id=278073&action=edit
kernel log

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
