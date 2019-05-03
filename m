Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41586 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfECUGx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 May 2019 16:06:53 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 62B82560
        for <linux-xfs@vger.kernel.org>; Fri,  3 May 2019 15:06:50 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs master updated to 65dcd3b
Message-ID: <215c5b02-9eb9-e626-f21b-c5c8404ae8e5@sandeen.net>
Date: Fri, 3 May 2019 15:06:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

65dcd3b xfsprogs: Release v5.0.0

New Commits:

Eric Sandeen (2):
      [868d0cc] xfs_io: rework includes for statx structures
      [65dcd3b] xfsprogs: Release v5.0.0

Jorge Guerra (1):
      [0c1d691] xfs_db: scan entire file system when using 'frag'


Code Diffstat:

 VERSION          | 2 +-
 configure.ac     | 2 +-
 db/frag.c        | 2 +-
 debian/changelog | 6 ++++++
 doc/CHANGES      | 4 ++++
 io/stat.c        | 3 ---
 io/statx.h       | 7 +++++++
 7 files changed, 20 insertions(+), 6 deletions(-)
 xfsprogs: Release v5.0.0

New Commits:

Eric Sandeen (2):
      [868d0cc] xfs_io: rework includes for statx structures
      [65dcd3b] xfsprogs: Release v5.0.0

Jorge Guerra (1):
      [0c1d691] xfs_db: scan entire file system when using 'frag'


Code Diffstat:

 VERSION          | 2 +-
 configure.ac     | 2 +-
 db/frag.c        | 2 +-
 debian/changelog | 6 ++++++
 doc/CHANGES      | 4 ++++
 io/stat.c        | 3 ---
 io/statx.h       | 7 +++++++
 7 files changed, 20 insertions(+), 6 deletions(-)
