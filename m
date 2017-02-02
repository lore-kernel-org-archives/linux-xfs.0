Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50119 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdBBH4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:17 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: 4.9-stable updates for XFS
Date: Thu,  2 Feb 2017 08:55:52 +0100
Message-Id: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports up to 4.10-rc6 for XFS.  I've selected all clear
bugfixes for reported bugs.  I've skipped the finobt space reservation
patch for now - I think it is stable material, but I want it to settle
a bit more first.

