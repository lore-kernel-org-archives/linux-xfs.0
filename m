Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdISOvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 10:51:12 -0400
Date: Tue, 19 Sep 2017 07:51:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: test case for "xfs: XFS_IS_REALTIME_INODE() should be false if no rt
 device present"
Message-ID: <20170919145111.GA20486@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi Richard,

can you send an xfstests test case for your XFS_IS_REALTIME_INODE()
fix?

