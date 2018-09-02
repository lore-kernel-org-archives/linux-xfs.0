Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbeIBM2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Sep 2018 08:28:51 -0400
Date: Sun, 2 Sep 2018 01:13:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/18] xfs: scrub the realtime rmapbt
Message-ID: <20180902081356.GA29175@infradead.org>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
 <153565400192.32612.147987129357562666.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153565400192.32612.147987129357562666.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

FYI, this fails in xfs_fs.h when applying to 4.19-rc1.

Maybe just push out the branch you are using somewhere if you get
around it.
