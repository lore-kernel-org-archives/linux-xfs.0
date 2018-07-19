Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731625AbeGSRZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 13:25:24 -0400
Date: Thu, 19 Jul 2018 09:41:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: return from _defer_finish with a clean
 transaction
Message-ID: <20180719164125.GE10151@infradead.org>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192904042.31685.60438652773989931.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192904042.31685.60438652773989931.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(no need to mention me in the changelog, though :))
