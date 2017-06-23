Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753667AbdFWH7x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 03:59:53 -0400
Date: Fri, 23 Jun 2017 15:59:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/8] miscellaneous tests
Message-ID: <20170623075950.GL23360@eguan.usersys.redhat.com>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jun 21, 2017 at 02:57:02PM -0700, Darrick J. Wong wrote:
> I decided to roll everything up into a patch series, though these
> patches mostly address different things.
> 
> So... I've reposted the ext4 fsmap test, fixed up some tests to
> reflect changes being finalized in xfsprogs 4.12, added a few more
> reflink stress tests, and added a couple of new scrub stress tests.

I've queued patch 3, 4 and 6 (which have been reviewed before) for this
week's update. And I still have some questions regarding the ext4 fsmap
tests (sorry I didn't bring them up in my first round review), so I'll
leave it to next week along with other new tests/patches.

Thanks,
Eryu
