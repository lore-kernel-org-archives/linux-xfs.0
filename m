Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932772AbeCMKtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 06:49:32 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evhUp-0006Dj-Hh
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 10:49:32 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: xfs_log_force related cleanups
Date: Tue, 13 Mar 2018 11:49:19 +0100
Message-Id: <20180313104927.12926-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

A couple cleanups and refactorig around xfs_log_force and friends.

