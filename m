Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43665 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162276AbdDURHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 13:07:38 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1aNF-0005Uj-Cn
        for linux-xfs@vger.kernel.org; Fri, 21 Apr 2017 15:21:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: a few sparse inspired cleanups / fixes
Date: Fri, 21 Apr 2017 17:21:17 +0200
Message-Id: <20170421152123.11316-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Starting from trivial to more intrusive near the end.

