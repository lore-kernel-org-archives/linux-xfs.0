Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbeLBQKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 11:10:21 -0500
Date: Sun, 2 Dec 2018 08:10:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS patches for stable
Message-ID: <20181202161016.GA27696@infradead.org>
References: <20181129060110.159878-25-sashal@kernel.org>
 <20181129121458.GK19305@dastard>
 <20181129124756.GA25945@kroah.com>
 <20181129224019.GM19305@dastard>
 <20181130082203.GA26830@kroah.com>
 <20181130101441.GA213156@sasha-vm>
 <20181130215005.GP19305@dastard>
 <20181201074909.GC213156@sasha-vm>
 <CAOQ4uxhCH3oxVWDMVRcXMZO3JSTCA1Pp5AYnHP5pDxyNktqONw@mail.gmail.com>
 <20181202152547.GI221015@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202152547.GI221015@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, Greg KH <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Luis R. Chamberlain" <mcgrof@kernel.org>

As someone who has done xfs stable backports for a while I really don't
think the autoselection is helpful at all.  Someone who is vaguely
familiar with the code needs to manually select the commits and QA them,
which takes a fair amount of time, but just needs some manual help if it
should work ok.

I think we are about ready to have a new xfs stable maintainer lined up
if everything works well fortunately.
