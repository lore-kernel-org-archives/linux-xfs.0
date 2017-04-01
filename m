Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43904 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdDAGkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:40:31 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: 4.9-stable updates for XFS
Date: Sat,  1 Apr 2017 08:39:59 +0200
Message-Id: <20170401064026.5783-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports up to 4.11-rc4 for XFS.  I've selected all clear
bugfixes for reported bugs.  In addition to the patches in 4.10-stable
there also are 2 patches that are in 4.10 but not in 4.9-stable yet
at the beginning of the series.
