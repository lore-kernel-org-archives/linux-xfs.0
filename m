Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbeLBUIX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 2 Dec 2018 15:08:23 -0500
Date: Sun, 2 Dec 2018 21:08:19 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: XFS patches for stable
Message-ID: <20181202200819.GA3932@kroah.com>
References: <20181129121458.GK19305@dastard>
 <20181129124756.GA25945@kroah.com>
 <20181129224019.GM19305@dastard>
 <20181130082203.GA26830@kroah.com>
 <20181130101441.GA213156@sasha-vm>
 <20181130215005.GP19305@dastard>
 <20181201074909.GC213156@sasha-vm>
 <CAOQ4uxhCH3oxVWDMVRcXMZO3JSTCA1Pp5AYnHP5pDxyNktqONw@mail.gmail.com>
 <20181202152547.GI221015@sasha-vm>
 <20181202161016.GA27696@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202161016.GA27696@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, stable <stable@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Luis R. Chamberlain" <mcgrof@kernel.org>

On Sun, Dec 02, 2018 at 08:10:16AM -0800, Christoph Hellwig wrote:
> As someone who has done xfs stable backports for a while I really don't
> think the autoselection is helpful at all.

autoselection for xfs patches has been turned off for a while, what
triggered this email thread was a core vfs patch that was backported
that was not obvious it was created by the xfs developers due to a
problem they had found.

> Someone who is vaguely familiar with the code needs to manually select
> the commits and QA them, which takes a fair amount of time, but just
> needs some manual help if it should work ok.
> 
> I think we are about ready to have a new xfs stable maintainer lined up
> if everything works well fortunately.

That would be wonderful news.

thanks,

greg k-h
