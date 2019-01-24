Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbfAXODZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Jan 2019 09:03:25 -0500
Date: Thu, 24 Jan 2019 09:03:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 5/6] xfs: create delalloc bmapi wrapper for full
 extent allocation
Message-ID: <20190124140323.GC2855@bfoster>
References: <20190123184131.46188-1-bfoster@redhat.com>
 <20190123184131.46188-6-bfoster@redhat.com>
 <20190124085109.GA24774@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124085109.GA24774@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 12:51:09AM -0800, Christoph Hellwig wrote:
> This looks fine as a temporary step to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

It probably doesn't make sense to land this patch without the next. Feel
free to grab it and squash it into your series if it's useful, but
otherwise we can just drop patches 5 and 6 from this series.

Brian
