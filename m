Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44890 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbfAJXGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jan 2019 18:06:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C27C929EFC
        for <linux-xfs@vger.kernel.org>; Thu, 10 Jan 2019 23:06:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 199915] NULL pointer dereference in xfs_bmap_extents_to_btree()
 when mounting and operating a crafted image
Date: Thu, 10 Jan 2019 23:06:34 +0000
Message-ID: <bug-199915-201763-hd0BGaniey@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199915-201763@https.bugzilla.kernel.org/>
References: <bug-199915-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=199915

--- Comment #4 from billodo@redhat.com ---
Is this still an issue?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
