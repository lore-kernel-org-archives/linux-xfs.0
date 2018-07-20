Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbeGTQxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 12:53:11 -0400
Date: Fri, 20 Jul 2018 09:04:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] xfs: refactor unmount record write
Message-ID: <20180720160415.GA12054@infradead.org>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
 <153195716953.16758.3719225666646928225.stgit@magnolia>
 <20180719174130.GK4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719174130.GK4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, Jul 19, 2018 at 10:41:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the writing of the unmount record into a separate helper.  No
> functionality changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
