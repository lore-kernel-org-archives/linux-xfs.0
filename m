Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42084 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732452AbfFMOPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 10:15:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7E4E520134
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 14:15:52 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203887] CGroup writeback is not supported by `xfs` filesystem
 leading to errors when using containers.
Date: Thu, 13 Jun 2019 14:15:50 +0000
Message-ID: <bug-203887-201763-zmLgdcXSIq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203887-201763@https.bugzilla.kernel.org/>
References: <bug-203887-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203887

--- Comment #1 from axel.borja.login@gmail.com ---
My nodes are running under RHEL with a kernel 4.14 and I encounter OOM errors
when writing with xfs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
