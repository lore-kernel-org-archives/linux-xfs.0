Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60330 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfA3MAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jan 2019 07:00:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7327F2E3D7
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jan 2019 12:00:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Wed, 30 Jan 2019 12:00:15 +0000
Message-ID: <bug-202441-201763-P5sGUg9qRk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #25 from Roger (rogan6710@gmail.com) ---
If I had been less strict in my testing I probably would have discovered that
the problem was present earlier than 4.19.3. Mr Gushins commit made it more
visible.

I'm going back to work after two days off, so I might not be able to respond
inside your working hours, but I'll keep checking in on this as I get a chance.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
