Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53714 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbfACXIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 18:08:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BDED02522B
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 23:08:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 23:08:05 +0000
Message-ID: <bug-202127-201763-4jkh4yc4fj@https.bugzilla.kernel.org/>
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

Chris Murphy (bugzilla@colorremedies.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla@colorremedies.com

--- Comment #6 from Chris Murphy (bugzilla@colorremedies.com) ---
What do you get for 'MegaCli64 -AdpAllInfo -aAll' and parse for firmware
revision? Current on the website is 24.22.0-0034 dated Oct 12 2018. Upgrading
it carries some risk *shrug* there might be a changelog you can download (now
at Broadcom) and see if there's anything related to this problem that's been
fixed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
