Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56082 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbfAVV4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 16:56:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F0A5C2B6D0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 21:56:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 21:56:43 +0000
Message-ID: <bug-202127-201763-3JmW5UCXRq@https.bugzilla.kernel.org/>
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

--- Comment #33 from Eric Sandeen (sandeen@sandeen.net) ---
Agreed.  I don't think we can possibly state clearly enough that the firmware
is buggy.  We can help you work around it, and add some things to the utilities
to catch it, but at the end of the day, your firmware /is/ buggy and your
vendor doesn't seem to understand that fact.  Good luck.  :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
