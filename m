Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50917 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763523AbdDST3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 15:29:08 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d0vHn-0001dr-AC
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 19:29:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: misc cleanups
Date: Wed, 19 Apr 2017 21:29:01 +0200
Message-Id: <20170419192904.22203-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Remove some unused #defines / enums and simplify the validation of
the unwritten extent bit.

