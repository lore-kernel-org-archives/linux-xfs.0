Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfEGQ5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:21 -0400
Subject: [PATCH 0/1] fstests: various new tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 May 2019 09:57:11 -0700
Message-ID: <155724823157.2624769.14347748235168250309.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Test that xfs_scrub can validate misleading unicode codepoints in
filesystem labels now that xfsprogs 5.0 has been released.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests
