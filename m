Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51914 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdKQT4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 14:56:45 -0500
Subject: [PATCH 0/5] xfsprogs: 4.15 rollup
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 11:56:41 -0800
Message-ID: <151094860143.27182.12022983202520916281.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some patches fixing up random odds and ends in 4.15.  xfs_db is
changed to print all padding fields, xfs_io starts pulling error tag
definitions from libxfs and talk to the scrub ioctl, and manpage updates
for the new scrub ioctl.

--D
