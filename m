Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45967 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbdC0IuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:50:22 -0400
Received: from 77-56-156-7.dclient.hispeed.ch ([77.56.156.7] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1csQL6-0001Ob-P7
        for linux-xfs@vger.kernel.org; Mon, 27 Mar 2017 08:49:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: 
Date: Mon, 27 Mar 2017 10:48:55 +0200
Message-Id: <20170327084922.11691-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

Subject: 4.9-stable updates for XFS
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports up to 4.11-rc4 for XFS.  I've selected all clear
bugfixes for reported bugs.  In addition to the patches in 4.10-stable
there also are 2 patches that are in 4.10 but not in 4.9-stable yet
at the beginning of the series.
