Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36405 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdIQVHM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:12 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: 4.9-stable updates for XFS
Date: Sun, 17 Sep 2017 14:06:25 -0700
Message-Id: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports up to 4.14-rc1 for XFS.  I've selected all
clear bugfixes for reported bugs, and a few harmless prep patches
that allow us to carry late bug fixes as-is instead of providing
special versions for -stable, which in the past have caused more
harm than good.

In addition to the patches for 4.13-stable there also are various
patches that are in 4.13 but not in 4.9-stable yet.
