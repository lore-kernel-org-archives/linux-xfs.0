Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57472 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfADBHB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 20:07:01 -0500
Date: Thu, 3 Jan 2019 17:06:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] iomap: more updates for v4.21
Message-ID: <20190104010645.GA12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Christoph Hellwig and I have decided to take responsibility for the fs
iomap code rather than let it languish further.  Let me know if you
encounter any problems with the merge.

--D

The following changes since commit 3cc31fa65d85610574c0f6a474e89f4c419923d5:

  iomap: don't search past page end in iomap_is_partially_uptodate (2018-12-21 08:42:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-4.21-merge-3

for you to fetch changes up to 31af12efd0a259de9b0d8ef626503911f13b584f:

  iomap: take responsibility for the filesystem iomap code (2018-12-21 08:43:05 -0800)

----------------------------------------------------------------
Changes since last update:
- Take responsibility for the iomap code.

----------------------------------------------------------------
Darrick J. Wong (1):
      iomap: take responsibility for the filesystem iomap code

 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)
