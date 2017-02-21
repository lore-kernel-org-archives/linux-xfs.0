Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33260 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752848AbdBUOrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 09:47:40 -0500
Date: Tue, 21 Feb 2017 15:47:16 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] xfs: clear delalloc and cache on buffered write failure
Message-ID: <20170221144716.GA988@kroah.com>
References: <1487684787-5004-1-git-send-email-bfoster@redhat.com>
 <20170221135639.GA26768@kroah.com>
 <20170221144000.GA3516@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221144000.GA3516@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Michal Hocko <mhocko@kernel.org>

On Tue, Feb 21, 2017 at 06:40:00AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 21, 2017 at 02:56:39PM +0100, Greg KH wrote:
> > For XFS patches, I need an explicit ack from the maintainer before
> > applying them, as per their instructions in the past...
> 
> Brian is one of the most active XFS contributors, you can trust him :)

Heh, ok, but I have been yelled at before for xfs stuff, so I'm a bit
skitish...

I'll queue this up for the next release, after this one that just
started a few hours ago.

thanks,

greg k-h
