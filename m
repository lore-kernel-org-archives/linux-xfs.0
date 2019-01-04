Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58184 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbfADXIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 18:08:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C7E67287FD
        for <linux-xfs@vger.kernel.org>; Fri,  4 Jan 2019 23:08:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Fri, 04 Jan 2019 23:08:42 +0000
Message-ID: <bug-202127-201763-fLsF1DVx9P@https.bugzilla.kernel.org/>
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

--- Comment #18 from Eric Sandeen (sandeen@sandeen.net) ---
Thanks for the clarification, Dave, I shouldn't have made that mistake.

New question for broadcom:

"How can the preferred IO size be smaller than the minimum efficient IO size?"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
