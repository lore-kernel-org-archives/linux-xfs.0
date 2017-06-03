Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41221 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdFCNSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:18:39 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: 4.9-stable updates for XFS
Date: Sat,  3 Jun 2017 15:18:11 +0200
Message-Id: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports up to (almost) 4.12-rc4 for XFS.  I've selected all
clear bugfixes for reported bugs.  In addition to the patches in
4.11-stable there also are 3 patches that are in 4.11 but not in
4.9-stable yet at the beginning of the series.
