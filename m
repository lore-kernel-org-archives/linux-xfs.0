Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41028 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbeJRBqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 21:46:19 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F2C68284DC
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 17:49:33 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201453] Bug 1640090 - [xfstests xfs/490]: xfs_db print a bad
 (negative number) as agi freecount
Date: Wed, 17 Oct 2018 17:49:33 +0000
Message-ID: <bug-201453-201763-qioL0HCrGu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201453-201763@https.bugzilla.kernel.org/>
References: <bug-201453-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201453

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Created attachment 279077
  --> https://bugzilla.kernel.org/attachment.cgi?id=279077&action=edit
xfs metadump

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
