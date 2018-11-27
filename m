Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55914 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727571AbeK0OaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 09:30:05 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E9C2028E54
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 03:33:38 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201793] [xfstests generic/299] XFS corruption found:
 sb_fdblocks 7302443, counted 7302451
Date: Tue, 27 Nov 2018 03:33:39 +0000
Message-ID: <bug-201793-201763-vWWwYjNjyI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201793-201763@https.bugzilla.kernel.org/>
References: <bug-201793-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201793

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
I've tried current upstream xfsprogs for-next branch, which HEAD is:
commit caa91046eee63f10635acefd559cdfb56e9e214e (HEAD -> for-next, tag:
v4.19.0, origin/master, origin/for-next, origin/HEAD, master)
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Nov 9 14:31:04 2018 -0600

    xfsprogs: Release v4.19.0

xfs_repair still report this corruption.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
