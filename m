Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfBTOO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 09:14:29 -0500
Date: Wed, 20 Feb 2019 06:14:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/450: require working falloc command
Message-ID: <20190220141427.GA31714@infradead.org>
References: <20190219183238.GI6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219183238.GI6477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Feb 19, 2019 at 10:32:38AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test needs to check for working falloc command before using it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
