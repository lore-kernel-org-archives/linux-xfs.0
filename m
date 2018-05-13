Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbeEMRAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 May 2018 13:00:41 -0400
Subject: [PATCH 0/4] xfs-docs: incorporate design documents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 13 May 2018 10:00:24 -0700
Message-ID: <152623082465.10242.9458731018482450171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, azarus@posteo.net

Hi all,

This series renames the old on-disk filesystem structure book to 'XFS
Algorithms and Data Structures', and moves the delayed logging and
self-describing metadata design documents into the book.  No changes
have been made to the contents of either document.  This series begins
the process of migrating the more up-to-date documentation into the
kernel.  See branch[1] if you actually want to build the docs.

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git/log/?h=djwong-devel
