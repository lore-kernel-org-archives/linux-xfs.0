Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40499 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752561AbeAEXmE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 18:42:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w05NRfLv121400
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 23:42:03 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2faj7f85fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jan 2018 23:42:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ng2Ts014458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 23:42:02 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ng2aF004329
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 23:42:02 GMT
Date: Fri, 5 Jan 2018 15:42:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-documentation: master updated to 14bbbf5
Message-ID: <20180105234201.GN5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

14bbbf5 xfsdocs: clarify log item header structure

New Commits:

Darrick J. Wong (2):
      [b208862] xfsdocs: fix some small discrepancies with libxfs
      [14bbbf5] xfsdocs: clarify log item header structure


Code Diffstat:

 design/XFS_Filesystem_Structure/btrees.asciidoc              |  2 +-
 design/XFS_Filesystem_Structure/dabtrees.asciidoc            |  8 ++++++--
 design/XFS_Filesystem_Structure/extended_attributes.asciidoc |  1 +
 design/XFS_Filesystem_Structure/internal_inodes.asciidoc     |  2 +-
 design/XFS_Filesystem_Structure/journaling_log.asciidoc      | 12 ++++++++++++
 5 files changed, 21 insertions(+), 4 deletions(-)
