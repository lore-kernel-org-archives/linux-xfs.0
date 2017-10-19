Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29841 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdJSUEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 16:04:25 -0400
Date: Thu, 19 Oct 2017 13:04:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: more extent mapping cleanups
Message-ID: <20171019200418.GM4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:27AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> This series contains another round of extent map related cleanups
> to prepare for the new incore extent list.
> 
> Because it is based on a huge number of outstanding (and reviewed)
> patches it might be a good idea to pull in the git tree for testing
> or detailed review:

Looks ok on first glance, will feed it to the testing cloud while I take
a closer look this afternoon.

--D

> 
> 	git://git.infradead.org/users/hch/xfs.git xfs-bmbt-cleanup.2
> 
> Gitweb:
> 
> 	http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-bmbt-cleanup.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
