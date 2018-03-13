Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbeCMOgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:05 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl24-0004Ym-Ex
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:04 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: misc fixes and cleanups
Date: Tue, 13 Mar 2018 15:35:53 +0100
Message-Id: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Below are a set of small fixes and cleanups that were the fallout of
not yet finished feature development.

