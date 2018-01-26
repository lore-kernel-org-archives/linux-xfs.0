Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51251 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbeAZJJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 04:09:21 -0500
Date: Fri, 26 Jan 2018 01:09:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] xfs: fix tracepoint %p formats
Message-ID: <20180126090919.GD29115@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676032777.12349.765325330406419659.stgit@magnolia>
 <20180125173127.GC44175@bfoster.bfoster>
 <20180125184704.GK9068@magnolia>
 <20180126001916.GS9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126001916.GS9068@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Please fix trace-cmd instead of losing the specifiers for the kernel
trace buffer.
