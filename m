Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55242 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbeGBOy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:54:59 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: more iomap inline enablement
Date: Mon,  2 Jul 2018 08:54:55 -0600
Message-Id: <20180702145458.22330-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org

Hi Darrick,

below are a few more iomap patches to enable inline data for the
iomap-4.19-merge branch.
