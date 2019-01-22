Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59704 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728915AbfAVPB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 10:01:28 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 238F82AC49
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 15:01:28 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 15:01:27 +0000
Message-ID: <bug-202127-201763-XgKDZZVMut@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #25 from Eric Sandeen (sandeen@sandeen.net) ---
Will it mount with "mount -o noalign" or "mount -o
sunit=$VALUE1,swidth=$VALUE2" ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
