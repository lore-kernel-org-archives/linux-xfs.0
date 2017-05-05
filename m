Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36414 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbdEETBk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 15:01:40 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2DEF17AE043
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2017 14:01:40 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.11.0 released!
Message-ID: <65f0bef0-b632-14e2-98ce-e1735f68758c@sandeen.net>
Date: Fri, 5 May 2017 14:01:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi Folks,

The xfsprogs repositories have just been updated and tagged with the
v4.11.0 release tag. It can be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.11.0

Release tarballs are hosted on kernel.org, and can be found here:

https://kernel.org/pub/linux/utils/fs/xfs/xfsprogs/

Many thanks go to all the contributors to this release. The summary
of changes since v4.7.0 can be found listed in doc/CHANGES, or below.

Onward to 4.12!  ;)

Cheers,

Eric.

----

xfsprogs-4.11.0 (5 May 2017)
        - xfs_io: man page fixups (Zorro Lang)

xfsprogs-4.11.0-rc2 (2 May 2017)
        - xfs_db: add btree dumping command (Darrick Wong)
        - mkfs.xfs: change bare -m rmapbt,reflink to enable (Eric Sandeen)
        - xfs_io: document -d option, enable for dqblks & inodes (Darrick Wong)
        - xfs_io: minor statx fixes, updates (Chandan Rajendra, Gwendal Grignou)

xfsprogs-4.11.0-rc1 (4 Apr 2017)
        - xfs_io: add statx support (David Howells, Eric Sandeen)
        - xfs_io: fix "falloc -p" to pass KEEP_SIZE (Calvin Owens)
        - xfs_io: support shutdown on foreign filesystems (Darrick Wong)
        - xfs_repair: repair zero-sized symlinks (Brian Foster)
        - xfs_repair: warn about dirty log with -n option (Eric Sandeen)
        - xfs.5: document barrier mount option deprecation (Eric Sandeen)

