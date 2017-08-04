Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdHDHAC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Aug 2017 03:00:02 -0400
Date: Fri, 4 Aug 2017 15:00:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/5] miscellaneous tests
Message-ID: <20170804070001.GE1991@eguan.usersys.redhat.com>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150067465981.30639.14801416171688538711.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi Darrick,

On Fri, Jul 21, 2017 at 03:04:19PM -0700, Darrick J. Wong wrote:
> I decided to roll everything up into a patch series, though these
> patches mostly address different things.
> 
> So... I've reposted the ext4 fsmap test, refactored the xfs error
> injection helpers to work with the new interface in 4.13, and added
> support for fuzzing xfs quota record fields.

I queued the first two patches (dryrun of xfs_scrub and ext4 fsmap
tests) in this week's update. Other patches may need more review cycles.

Thanks,
Eryu
