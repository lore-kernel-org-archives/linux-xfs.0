Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731663AbeGSRY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 13:24:27 -0400
Date: Thu, 19 Jul 2018 09:40:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: force summary counter recalc at next mount
Message-ID: <20180719164029.GC10151@infradead.org>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
 <153195717556.16758.14300971459515094159.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153195717556.16758.14300971459515094159.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I assume we are going to get a test case ASAP that is going to use this?
