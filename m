Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752639AbdBUOkH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 09:40:07 -0500
Date: Tue, 21 Feb 2017 06:40:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: clear delalloc and cache on buffered write failure
Message-ID: <20170221144000.GA3516@infradead.org>
References: <1487684787-5004-1-git-send-email-bfoster@redhat.com>
 <20170221135639.GA26768@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221135639.GA26768@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: Brian Foster <bfoster@redhat.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Michal Hocko <mhocko@kernel.org>

On Tue, Feb 21, 2017 at 02:56:39PM +0100, Greg KH wrote:
> For XFS patches, I need an explicit ack from the maintainer before
> applying them, as per their instructions in the past...

Brian is one of the most active XFS contributors, you can trust him :)
