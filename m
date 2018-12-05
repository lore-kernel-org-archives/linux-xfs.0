Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55408 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726909AbeLEInj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 03:43:39 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5B40128501
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 08:43:38 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201897] [xfstests generic/482]: filesystem corruption after log
 replay
Date: Wed, 05 Dec 2018 08:43:38 +0000
Message-ID: <bug-201897-201763-j8HqH8RlQf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201897-201763@https.bugzilla.kernel.org/>
References: <bug-201897-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201897

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
Created attachment 279863
  --> https://bugzilla.kernel.org/attachment.cgi?id=279863&action=edit
corrupted xfs metadump on v4.20-rc4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
