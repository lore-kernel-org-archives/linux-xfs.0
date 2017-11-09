Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46628 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753155AbdKIN1D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:03 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: incore extent b+tree fixups
Date: Thu,  9 Nov 2017 14:26:50 +0100
Message-Id: <20171109132656.1649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

A couple small patches to fix issue pointed out by Brian.

