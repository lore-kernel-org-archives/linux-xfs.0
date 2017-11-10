Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22535 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbdKJAo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 19:44:27 -0500
Subject: [PATCH 0/4] rollup of fstests fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 09 Nov 2017 16:44:21 -0800
Message-ID: <151027466195.13147.10381301768189156101.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

This is a rollup of all the patches I've been sending to the list.
The first patch fixes some problems seen with the new xfsprogs 4.14
release candidate; the second patch removes pad fields from the
fuzzing infrastructure; and the rest are all repeats from last week.

--D
