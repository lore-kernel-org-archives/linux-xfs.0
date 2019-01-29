Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46854 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727332AbfA2WHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 17:07:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AB63E2CD86
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 22:07:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 22:07:09 +0000
Message-ID: <bug-202441-201763-FdVWbjyDde@https.bugzilla.kernel.org/>
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

--- Comment #17 from Roger (rogan6710@gmail.com) ---
I suspected that commit as well...
I would love to try that revert. I have never done one so I'm not sure how to
go about it. I'll have to read up a little.
Do I revert in 4.19.3 or the latest ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
