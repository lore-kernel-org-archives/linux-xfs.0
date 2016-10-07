Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43759 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcJGXHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:07:23 -0400
Subject: [PATCH 0/7] xfs: reflink fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:14 -0700
Message-ID: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's all the fixes[1] for reflink I've collected against the latest
for-next kernel branches.  They're all minor bug fixes that came up
in review or on irc.  They've survived a quick go-round with the
clone tests.

--D

[1] https://github.com/djwong/linux/tree/for-dave-for-4.9-14
