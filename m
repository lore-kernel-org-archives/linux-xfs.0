Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49246 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbeKMID2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 03:03:28 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DB6D42A2E7
        for <linux-xfs@vger.kernel.org>; Mon, 12 Nov 2018 22:08:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200063] XFS corruption: mismatch between format (2) and size
 (0) in symlink
Date: Mon, 12 Nov 2018 22:08:22 +0000
Message-ID: <bug-200063-201763-Kvmn3RXe7x@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200063-201763@https.bugzilla.kernel.org/>
References: <bug-200063-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200063

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
On Mon, Nov 12, 2018 at 01:31:26PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=200063
> 
> --- Comment #4 from Zorro Lang (zlang@redhat.com) ---
> I still can reproduce this bug on linux v4.20-rc1. So we haven't merged this
> patch (in comment 3), right?

Patch was superceded, and I never got around to posting the new
version. It's still sitting in my stack, I'll try to get it out in
the next coupel of days.

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
