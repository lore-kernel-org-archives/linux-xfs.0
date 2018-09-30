Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43620 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbeI3Gg5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 02:36:57 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AF8972993C
        for <linux-xfs@vger.kernel.org>; Sun, 30 Sep 2018 00:06:27 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201287] xfsprogs 4.17 and later can't be built as static
 binaries anymore
Date: Sun, 30 Sep 2018 00:06:26 +0000
Message-ID: <bug-201287-201763-52jfFh2E34@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201287-201763@https.bugzilla.kernel.org/>
References: <bug-201287-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201287

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
Is there a recipe to demonstrate this failure in the upstream git tree w/o the
gentoo patches or build environment?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
