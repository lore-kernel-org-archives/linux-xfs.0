Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A873CC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 22:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B7020738
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 22:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHXWsE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 18:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHXWsD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 18:48:03 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209005] xfs_repair 5.7.0: missing newline in message: entry at
 block N offset NN in directory inode NNNNNN has illegal name "/foo":
Date:   Mon, 24 Aug 2020 22:48:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: cs@cskk.id.au
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209005-201763-YKGtdhI7bI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209005-201763@https.bugzilla.kernel.org/>
References: <bug-209005-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209005

--- Comment #8 from Cameron Simpson (cs@cskk.id.au) ---
No worries. Let me know if I can add info; I've got to down the FS at somepoint
today or tomorrow to reboot the NAS, which is being sullen. A prime opportunity
to rerun an xfs_repair, which I will do anyway, since I've just thrown another
2TB into it.

Any special options for the xfs_repair run to produce a log or transcript, or
any pre-repair dump instructions I could do (eg the metadump you mentioned)?

I'd like to do these things anyway this time around.

Cheers,
Cameron

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
